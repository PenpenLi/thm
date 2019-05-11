local M = class("BossEntityData",StageDefine.BaseEntityData)

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

return M