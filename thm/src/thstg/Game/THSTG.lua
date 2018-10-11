local M = class("Game",THSTG.Game)

--[[以下函数由子类重载]]--
function M:onEnv(gameRoot)
    --添加(LUA)包含路径
    package.path = package.path ..';thstg/Game/?.lua'
    --添加资源搜索路径
    cc.FileUtils:getInstance():addSearchPath("src/thstg/Game/")

    --初始化环境
    require "Scripts.EnvBase"

    require "Scripts.EnvGame"

    return true
end

function M:onScene()
    local mainScene = require("Scripts.Modules.Test.TestView"):create()
    return mainScene
end

return M