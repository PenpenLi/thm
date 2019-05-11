local M = class("PropEntityData",StageDefine.BaseEntityData)

function M:ctor(...)
    M.super.ctor(self,...)
end


function M:getEffect()
    return self:getConfigData().effect
end

function M:getEffectEx()
    return self:getConfigData().effectEx
end

function M:getEffectStr()
    return self:getConfigData().effectStr
end


return M