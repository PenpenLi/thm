module(..., package.seeall)

local M = class("HealthBarPrefab",StageDefine.BaseEntity)

function M:ctor(...)
    M.super.ctor(self)

    self:addScript(StageDefine.HealthBarController.new())
end


----------


return M