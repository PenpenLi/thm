module(..., package.seeall)

local M = class("EnemyEntity", StageDefine.LivedEntity)

function M:ctor()
    M.super.ctor(self)
    
end
return M