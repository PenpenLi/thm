local M = class("TH08",THSTG.Game)

function M:_onEnv()
    --初始化环境
    require "EnvBase"
    require "EnvGame"

    --随机数种子
    math.randomseed(os.time())

    --初始化管理器
    ControllerHandler.init()

    return true
end

function M:_onScene()
    --创建第一个场景
    local mainView = require("Modules.Game.GameModule"):create()
    -- local mainScene = require("Modules.Test.TestModule"):create()
    return mainView
end

return M