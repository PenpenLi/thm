
local M = class("System")

function M:ctor(...)

    
    self:_onInit(...)
end

function M:update(delay)
    self:_onUpdate(delay)
end
---
--[[系统生命周期]]
function M:_onInit(...)
    
end

--[[以下需要被重载]]
function M:_onUpdate(delay)
    --通过对Entity获取到相应的Component
end

return M