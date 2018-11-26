----------------------------------------------------
-- 本文件用于管理更新完成后的游戏流程
----------------------------------------------------
module("FlowManager", package.seeall)

local s_needClear = false


--开始运行
function run()
	ControllerHandler.init()
	LayerManager.init()

	--TODO:进入模块场景,进入初始化的那个
	enterMainScene()
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

	-- Dispatcher.clear()

	Cache.clear()
	ModuleManager.closeAll()
	ControllerHandler.clear()
	ControllerHandler.init()
	LayerManager.init()

end

function enterMainScene()
	--创建第一个场景
	local mainView,transition = require("Scripts.Modules.Game.GameModule"):create()
	-- local mainScene = require("Modules.Test.TestModule"):create()
	mainView:showWithScene(transition)
end

function enterGameScene()
	ModuleManager.closeAll()
	print("2: 进入游戏场景！")
	ModuleManager.open(ModuleType.GUI, {isResident = true})
end
