module(..., package.seeall)
local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local M = class("PlayerPrefab",StageDefine.PlayerEntity)

function M:ctor(...)
    M.super.ctor(self)

    self:addSystem(StageDefine.PlayerControlSystem.new())
    self:addSystem(StageDefine.PlayerAnimationSystem.new())

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