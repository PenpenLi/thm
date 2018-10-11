----------------------------------------------------
-- 本文件用于管理更新完成后的游戏流程
----------------------------------------------------
module("FlowManager", package.seeall)

local s_needClear = false


local function onEnterForeBackGround(isForeground)
	if isForeground then
		Dispatcher.dispatchEvent(EventType.APP_ENTER_FOREGROUND)
	else
		Dispatcher.dispatchEvent(EventType.APP_ENTER_BACKGROUND)
	end
end

local function onScreenOrientationChanged(safeArea)
	Dispatcher.dispatchEvent(EventType.SCREEN_ORIENTATION_CHANGED, safeArea)
end

local function onLifecycleChanged(value)
	Dispatcher.dispatchEvent(EventType.APP_LIFECYCLE_CHANGED, value)
end

local function onReceiveMemoryWarning()
	Dispatcher.dispatchEvent(EventType.APP_RECEIVE_MEMORY_WARNING)
end

local function onNetworkStatusChanged(status)
	Dispatcher.dispatchEvent(EventType.NETWORK_STATUS_CHANGED, status)
end

--开始运行
function run()
	DeviceUtil.setCallbacks(onEnterForeBackGround,onScreenOrientationChanged,onLifecycleChanged,onReceiveMemoryWarning,onNetworkStatusChanged)

	GameProxy.init()
	GameController.init()
	LayerManager.init()
	--语音初始化
	SpeechUtil.init()
	PushNotificationManager.init()
	--初始化sdk
	SDKUtil.init()

	restoreLoaded()

	if rawget(_G, "__IGONRE_LOGIN__") then
		enterGameScene()
	else
		enterLoginScene()
	end
end

--关闭游戏
function quitGame()
	cc.Director:getInstance():endToLua()
end

function clear()
	if not s_needClear then
		s_needClear = true
		return
	end

	-- 清理
	Scheduler.unscheduleAll()
	cc.Director:getInstance():getActionManager():removeAllActions()

	Dispatcher.clear()
	CountDownUtil.clear()

	MapDefines.MapConfig.clear()
	Cache.clear()
	ModuleManager.closeAll()
	GameController.clear()
	GameController.init()
	LayerManager.init()
	ResUpdateManager.stopDownload()
end

-- 返回登录
function backToLogin()
	--重连需要保存之前的账号信息，防止唤出sdk登陆界面
	clear()
	s_needClear = false
	Cache.loginCache.loginServerReturn = false
	Cache.loginCache.isSwitchRoleOnly = false
	enterLoginScene()
end

-- 快速重连
function fastLogin()
	Dispatcher.dispatchEvent(EventType.LOGIN_COMMON, "login")
end

-- 切换角色
function switchRole()
	Scheduler.schedule(backToLogin, 5, 1)

	--断线回调时机貌似不定，所以在前后各设置一下切账号状态,连接成功后再置回false
	Cache.settingCache.setSwitchAccount(true)

	--断开loginSession跟GateSession
	SessionManager.abandon(Rmi.SessionType.LoginSession)
	SessionManager.abandon(Rmi.SessionType.GateSession)

	Cache.roleCache.clear()
	Cache.loginCache:switchRole()
	Dispatcher.dispatchEvent(EventType.LOGIN_COMMON, "login")
end

--切换帐号
function switchAccount()
	Scheduler.scheduleOnce(0, function()
		--断线回调时机貌似不定，所以在前后各设置一下切账号状态,连接成功后再置回false
		Cache.settingCache.setSwitchAccount(true)

		--断开loginSession跟GateSession
		SessionManager.abandon(Rmi.SessionType.LoginSession)
		SessionManager.abandon(Rmi.SessionType.GateSession)

		Cache.loginCache:switchAccount()
		backToLogin()
	end)
end

function enterLoginScene()	
	ModuleManager.closeAll()
	print("1:进入登录场景！")
	ModuleManager.open(ModuleType.LOGIN, {closeOthers = true, playSound = false})
	ModuleManager.open(ModuleType.MSG_BOARD, {isResident = true})
end

function enterGameScene()
	ModuleManager.closeAll()
	print("2: 进入游戏场景！")
	ModuleManager.open(ModuleType.MSG_BOARD, {isResident = true})
	ModuleManager.open(ModuleType.MAIN_UI, {isResident = true})
	ModuleManager.open(ModuleType.MAP, {isResident = true})
	ModuleManager.open(ModuleType.TASK_TRACE, {isResident = true})
	ModuleManager.open(ModuleType.CHAT, {isResident = true})
	ModuleManager.open(ModuleType.NEWBIE, {isResident = true})

	-- PHPUtil.reportStep(ReportStepType.STEP_9)
end
