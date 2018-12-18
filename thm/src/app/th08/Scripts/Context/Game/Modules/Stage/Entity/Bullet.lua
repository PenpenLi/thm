module(..., package.seeall)

local M = class("Bullet",StageDefine.BulletPrefab)

function M:ctor()
    M.super.ctor(self)
   
end

----------
function M:_onEnter()
    
end

function M:_onExit()
   
end

function M:_onUpdate()

end

return M