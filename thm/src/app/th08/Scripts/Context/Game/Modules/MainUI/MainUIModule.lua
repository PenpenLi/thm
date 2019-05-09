module(..., package.seeall)

local M = class("MainUIModule", THSTG.MVC.Module)

function M:_onInit()

end

function M:_initViewClass()
    return "Scripts.Context.Game.Modules.MainUI.MainUIView"
end

function M:_initCtrlClass()
    return "Scripts.Context.Game.Modules.MainUI.MainUIController"
end


return M