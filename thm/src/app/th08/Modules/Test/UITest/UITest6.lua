module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local _scheduledTask = THSTG.COMMON.newScheduledTask()
   
    -------View-------
    local node = THSTG.UI.newNode()

    --相当于一份可复用的任务表,在什么时间执行什么
    --




    --一份剧本(制定演员何时上台表演,什么剧本,上去几个人,谁上去)
    --演员要执行规定剧本(做什么动作,说什么话,什么时候退场)

    -------Controller-------
    local function calculateBoundX(node,index,gap,isLeftToRight)
        if isLeftToRight then
            local ret = display.width + (((1-node:getAnchorPoint().x) * node:getContentSize().width) + (index - 1) * (gap + node:getContentSize().width))
        else
            return 0 - ((node:getAnchorPoint().x * node:getContentSize().width) + (index - 1) *(gap + node:getContentSize().width))
        end
    end

    local function calculateBoundY(node,index,gap,isTopToBottom)
        if isTopToBottom then
            return 0 - (((1-node:getAnchorPoint().y) * node:getContentSize().height) + (index - 1) *(gap + node:getContentSize().height))
            
        else
            return display.height + ((node:getAnchorPoint().y * node:getContentSize().height) + (index - 1) * (gap + node:getContentSize().height))
        end
    end

    local function calculateTimeByConstantSpeed(node,destPos,speed)
        local curPos = cc.p(node:getPosition())
        local shift = cc.pSub(destPos, curPos) 
        local length = cc.pGetLength(shift)

        return length/speed
    end

    local function calMoveToBySpeed(node,destPos,speed)
        return calculateTimeByConstantSpeed(node,destPos,speed),destPos
    end

    local TASK_TABLE = {
        {
            time = 1,
            callback  = function (sender)
                --左边生成三个小怪,并向下移动
                for i = 1,3 do
                    local critter = THSTG.UI.newNode({
                        x = 40,
                        y = display.height - (i-1) * 60,
                        height = 40,
                        width = 40,
                        anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
                    })
                    
                    node:addChild(critter)
                    debugUI(critter)

                    local actions = {}
                    table.insert(actions, cc.MoveBy:create(8.0,cc.p(0,-(2*display.height))))  
                    table.insert(actions,cc.CallFunc:create(function ()
                        sender:resume()
                        critter:removeFromParent()
                        
                    end))
                    sender:pause()
                    critter:runAction(cc.Sequence:create(actions))
                end
            end
        },
        {
            time = 12,
            callback  = function (sender)
                print(15,sender:time())
            end,
        },
        {
            time = 4,
            callback  = function (sender)
                print(15,sender:time())
            end,
        },
        {
            time = 4,
            callback = function (sender)
                --从左往右
                for i = 1,6 do
                    local critter = THSTG.UI.newNode({
                        x = 40 - i*60,
                        y = display.cy,
                        height = 40,
                        width = 40,
                        anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
                    })
                    critter:setPositionX(calculateBoundX(critter,i,10,false))
                    node:addChild(critter)
                    debugUI(critter)

                    local actions = {}
                    table.insert(actions, cc.MoveBy:create(8.0,cc.p((2*display.width),0)))
                    table.insert(actions,cc.CallFunc:create(function ()
                        critter:removeFromParent()
                    end))
                    
                    critter:runAction(cc.Sequence:create(actions))
                end
            end,  
        },
        {
            time = 2.3,
            callback = function (sender)
                --从右往左
                for i = 1,6 do
                    local critter = THSTG.UI.newNode({
                        x = display.width + i*60,
                        y = display.cy,
                        height = 40,
                        width = 40,
                        anchorPoint = THSTG.UI.POINT_RIGHT_CENTER,
                    })
    
                    node:addChild(critter)
                    debugUI(critter)

                    local actions = {}
                    table.insert(actions, cc.MoveBy:create(8.0,cc.p(-(2*display.width),0)))
                    table.insert(actions,cc.CallFunc:create(function ()
                        critter:removeFromParent()
                    end))
                    
                    critter:runAction(cc.Sequence:create(actions))
                end
            end,  
        },
        {
            time = 1.5,
            callback = function (sender)
                print(15,sender:time())
            end,  
        },
        {
            time = 1,
            callback = function (sender)
                -- 右边生成2个小怪,向上移动

                 for i = 1,2 do
                    local critter = THSTG.UI.newNode({
                        x = display.width - 40,
                        y = 0 - (i-1) * 60,
                        height = 40,
                        width = 40,
                        anchorPoint = THSTG.UI.POINT_RIGHT_TOP,
                    })
                    critter:setPositionY(calculateBoundY(critter,i,10,true))
                    node:addChild(critter)
                    debugUI(critter)

                    local actions = {}
                    table.insert(actions,cc.MoveBy:create(8.0,cc.p(0,(2*display.height))))
                    table.insert(actions,cc.CallFunc:create(function ()
                        critter:removeFromParent()
                    end))
                    
                    critter:runAction(cc.Sequence:create(actions))
                end
            end,
        },
    }
    _scheduledTask:setTasks(TASK_TABLE)
 
    ----
    local function updateFrame()
        _scheduledTask:poll()
    end

    node:onNodeEvent("enter", function ()
        node:scheduleUpdateWithPriorityLua(updateFrame,0)
    end)

    node:onNodeEvent("exit", function ()
        node:unscheduleUpdate()
    end)



  

    return node
end

return M