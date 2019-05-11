local M = class("PlayerEntityData",StageDefine.BaseEntityData)

function M:ctor(...)
    M.super.ctor(self,...)
end

function M:getNameDesc()
    return self:getConfigData().name
end

function M:getNicknameDesc()
    return self:getConfigData().nickname
end

function M:getAbilityDesc()
    return self:getConfigData().ability
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

function M:getExtra()
    return self:getConfigData().extra
end

return M