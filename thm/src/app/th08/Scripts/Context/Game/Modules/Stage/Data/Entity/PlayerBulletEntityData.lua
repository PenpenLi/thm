local M = class("PlayerBulletEntityData",StageDefine.BaseEntityData)

function M:ctor(...)
    M.super.ctor(self,...)
end

function M:getCategory()
    return self:getConfigData().category
end

function M:getType()
    return self:getConfigData().type
end

function M:getEffect()
    return self:getConfigData().effect
end

function M:getLife()
    return self:getConfigData().life
end

function M:getHarm()
    return self:getConfigData().harm
end

function M:getFreq()
    return self:getConfigData().freq
end

function M:getSpeed()
    return self:getConfigData().speed
end

return M