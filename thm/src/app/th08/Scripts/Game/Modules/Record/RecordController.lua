module(..., package.seeall)
local M = class("RecordController", Controller)

function M:_initViewClass()
    return "Scripts.Game.Modules.Record.RecordView"
end

function M:_onInit()

end


return M