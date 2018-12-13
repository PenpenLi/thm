
local M = class("System")

function M:ctor()
    self:_onInit()
end

----
function M:update()
    self:_onUpdate()
end

---
function M:_onInit()
    
end

--[[以下需要被重载]]
function M:_onUpdate()
    --通过对Entity获取到相应的Component
end


return M