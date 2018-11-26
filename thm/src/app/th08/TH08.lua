local M = class("TH08",THSTG.Game)

function M:_onEnv()
    --初始化环境
    require "Scripts.EnvBase"
    require "Scripts.EnvGame"

    return true
end

function M:_onInit()

    --随机数种子
    math.randomseed(os.time())

    --初始化管理器
	ControllerHandler.init()
	LayerManager.init()

    return true
end

function M:_onRun()


    --启动管理器
    -- FlowManager.run()


    local mainView,transition = require("Scripts.Modules.GUI.GUIModule"):create()
	-- local mainScene = require("Modules.Test.TestModule"):create()
	mainView:showWithScene(transition)
end

return M