local M = class("TH08",THSTG.Game)

function M:onEnv()
    --添加包含路径
    package.path = package.path ..';app/th08/?.lua'

    --初始化环境
    require "EnvBase"

    require "EnvGame"



    return true
end

function M:onScene()
    --创建第一个场景
    -- local mainScene = require("Modules.Scenes.MainUi.MainScene"):create()
    local mainScene = require("Modules.Test.TestModule"):create()
    return mainScene
end

return M