local M = class("FlagComponent",THSTG.ECS.Component)

function M:_onInit()
    self.flag = nil
end

return M