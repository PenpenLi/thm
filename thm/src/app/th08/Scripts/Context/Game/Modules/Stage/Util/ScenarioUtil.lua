module(..., package.seeall)


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