module(..., package.seeall)

local M = class("LilyWhite",StageDefine.EnemyEntity)

function M:ctor()
    M.super.ctor(self)
    debugUI(self)
   
end
----------
function M:shot()
    local bullet = StageDefine.Bullet.new()
    bullet:addTo(THSTG.SceneManager.get(SceneType.STAGE).entityLayer)

end


----------
function M:_onEnter()
    
end

function M:_onExit()
   
end

function M:_onUpdate()

end

return M