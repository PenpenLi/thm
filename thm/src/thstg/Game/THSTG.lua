
local M = class("Game",THSTG.Game)

--[[以下函数由子类重载]]--
function M:_onEnv(gameRoot)
    --初始化环境
    require "Scripts.EnvBase"
    require "Scripts.EnvGame"

    --
    

    return true
end

function M:_onRun()
    local mainView,transition = require("Scripts.Modules.Test.TestView"):create()
    mainView:showWithScene(transition)
end

return M