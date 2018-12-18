module(..., package.seeall)

local M = class("LilyWhite",StageDefine.BatmanPrefab)

function M:ctor()
    M.super.ctor(self)
 
   
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