local M = class("BatmanEntityData",StageDefine.BaseEntityData)

function M:ctor(...)
    M.super.ctor(self,...)
end

function M:getType()
    return self:getConfigData().type
end

function M:getLife()
    return self:getConfigData().life
end

function M:getSpeed()
    return self:getConfigData().speed
end

return M