local M = class("Game",THSTG.Game)

--[[以下函数由子类重载]]--
function M:onEnv(gameRoot)
    --添加包含路径
    package.path = package.path ..';thstg/Game/?.lua'

    --初始化环境
    require "Scripts.EnvBase"

    require "Scripts.EnvGame"

    return true
end

function M:onScene()
    local mainScene = require("Scripts.Modules.Test.UITest.TestModule"):create()
    return mainScene
end

return M