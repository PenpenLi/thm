module(..., package.seeall)

local M = class("StageModule", THSTG.MVC.Module)

function M:_onInit()
    Cache.register("stageCache","Scripts.Context.Game.Modules.Stage.StageCache")
end

function M:_initViewClass()
    return "Scripts.Context.Game.Modules.Stage.StageView"
end

function M:_initCtrlClass()
    return "Scripts.Context.Game.Modules.Stage.StageController"
end


return M