module(..., package.seeall)

local M = class("TestModule", THSTG.MVC.Module)

function M:_onInit()
    
end

function M:_initViewClass()
    return "Scripts.Context.Game.Modules.Test.TestView"
end

function M:_initCtrlClass()
    return "Scripts.Context.Game.Modules.Test.TestController"
end

return M