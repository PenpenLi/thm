module(..., package.seeall)
local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType

function animiation(entity)
end

function move(entity)
    local inputComp = entity:getComponent("InputComponent")
    if inputComp then
       local keyMapper = inputComp.keyMapper
       local moveStep = cc.p(0,0)
       if keyMapper:isKeyDown(EGameKeyType.MoveLeft) then
           moveStep.x = -Definition.Public.PLAYER_MOVE_STEP
       end
       if keyMapper:isKeyDown(EGameKeyType.MoveRight) then
           moveStep.x = Definition.Public.PLAYER_MOVE_STEP
       end
       if keyMapper:isKeyDown(EGameKeyType.MoveUp) then
           moveStep.y = Definition.Public.PLAYER_MOVE_STEP
       end
       if keyMapper:isKeyDown(EGameKeyType.MoveDown) then
           moveStep.y = -Definition.Public.PLAYER_MOVE_STEP
       end
       local oldX,oldY = entity:getPosition()
       entity:setPosition(cc.p(oldX+moveStep.x,oldY+moveStep.y))
   end
end