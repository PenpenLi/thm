----------------------------------------------------
-- 本文件用于管理更新完成后的游戏流程
----------------------------------------------------
module("FlowManager", package.seeall)

local s_needClear = false


--开始运行
function run()
	
	LayerManager.init()
	ControllerManager.init()

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
	ControllerManager.clear()
	ControllerManager.init()
	LayerManager.init()

end
