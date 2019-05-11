module("ScenarioUtil", package.seeall)
----------------------------------------

local function _initEntity(entity,curI,initFunc)
    local initPos,initSpeed,initAction = false,false,false
    if type(initFunc) == "function" then
        initPos,initSpeed,initAction = initFunc(curI,entity)
    end

    if initPos then
        local transComp = entity:getComponent("TransformComponent")
        transComp:setPosition(initPos)
    end

    if initSpeed then
        local rigidComp = entity:getComponent("RigidbodyComponent")
        rigidComp:setSpeed(initSpeed)
    end

    if initAction then
        local actionComp = entity:getComponent("ActionComponent")
        actionComp:runOnce(initAction)
    end

    entity:setLocalZOrder(curI)
    Dispatcher.dispatchEvent(EventType.STAGE_ADD_ENTITY,entity)
end


function takeEnemyBullets(type,num,initFunc)
    num = num or 1
    for i = 1,num do
        local entity = EntityManager.createEnemyBullet(type)
        _initEntity(entity,i,initFunc)
    end
end


function takeBatmans(type,num,initFunc)
    num = num or 1
    for i = 1,num do
        local entity = EntityManager.createBatman(type)
        _initEntity(entity,i,initFunc)
    end
end

function takeProps(type,num,initFunc)
    num = num or 1
    for i = 1,num do
        local entity = EntityManager.createProp(type)
        _initEntity(entity,i,initFunc)
    end
end
----------------------------------------
function calculateBoundX(node,index,gap,isLeftToRight)
    if isLeftToRight then
        local ret = display.width + (((1-node:getAnchorPoint().x) * node:getContentSize().width) + (index - 1) * (gap + node:getContentSize().width))
    else
        return 0 - ((node:getAnchorPoint().x * node:getContentSize().width) + (index - 1) *(gap + node:getContentSize().width))
    end
end

function calculateBoundY(node,index,gap,isTopToBottom)
    if isTopToBottom then
        return 0 - (((1-node:getAnchorPoint().y) * node:getContentSize().height) + (index - 1) *(gap + node:getContentSize().height))
        
    else
        return display.height + ((node:getAnchorPoint().y * node:getContentSize().height) + (index - 1) * (gap + node:getContentSize().height))
    end
end

function calculateTimeByConstantSpeed(node,destPos,speed)
    local curPos = cc.p(node:getPosition())
    local shift = cc.pSub(destPos, curPos) 
    local length = cc.pGetLength(shift)

    return length/speed
end

function calMoveToBySpeed(node,destPos,speed)
    return calculateTimeByConstantSpeed(node,destPos,speed),destPos
end

------
function calCirclePos(centerPos,radius,total,num)
    centerPos = centerPos or cc.p(display.cx,display.cy)
    num = num or total

    --
    local initPosX = display.cx
    local initPosY = display.cy

    local angle = num/total * 360 * (math.pi/180)
    local initPosX = centerPos.x + radius * math.cos(angle)
    local initPosY = centerPos.y + radius * math.sin(angle)

    return cc.p(initPosX,initPosY)
end