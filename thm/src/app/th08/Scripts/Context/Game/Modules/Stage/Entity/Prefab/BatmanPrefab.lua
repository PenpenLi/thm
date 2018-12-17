module(..., package.seeall)

local M = class("BatmanPrefab",StageDefine.EnemyEntity)

function M:ctor()
    M.super.ctor(self)
    debugUI(self)
   
end

----------
function M:_onEnter()

    
end

function M:_onExit()
   
end

function M:_onUpdate()

end

return M