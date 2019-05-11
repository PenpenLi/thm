local M = class("EnemyBulletEntityData",StageDefine.BaseEntityData)

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

return M