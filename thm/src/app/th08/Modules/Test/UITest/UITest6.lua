module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------

   
    -------View-------
    local node = THSTG.UI.newNode()

    --相当于一份可复用的任务表,在什么时间执行什么
    --




    --一份剧本(制定演员何时上台表演,什么剧本,上去几个人,谁上去)
    --演员要执行规定剧本(做什么动作,说什么话,什么时候退场)

    -------Controller-------
    local function calculateBoundX(node,index,gap,isLeftToRight)
        if isLeftToRight then
            return display.width + (((1-node:getAnchorPoint().x) * node:getContentSize().width) + (index - 1) * (gap + node:getContentSize().width))
        else
            return 0 - ((node:getAnchorPoint().x * node:getContentSize().width) + (index - 1) *(gap + node:getContentSize().width))
        end
    end

    local function calculateBoundY(node,index,gap,isBottomToTop)
        if isBottomToTop then
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


    local FUNC_TABLE = {
        {
            time = 5,
            callback  = function (time)
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
                        critter:removeFromParent()
                    end))
                    
                    critter:runAction(cc.Sequence:create(actions))
                end
            end
        },
        {
            time = 120,
            callback  = function (time)
                print(15,time)
            end,
        },
        {
            time = 400,
            callback  = function (time)
                print(15,time)
            end,
        },
        {
            time = 30,
            callback = function (time)
                --从左往右
                for i = 1,6 do
                    local critter = THSTG.UI.newNode({
                        x = 40 - i*60,
                        y = display.cy,
                        height = 40,
                        width = 40,
                        anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
                    })
    
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
            time = 30,
            callback = function (time)
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
            time = 200,
            callback = function (time)
                print(15,time)
            end,  
        },
        {
            time = 5,
            callback = function (time)
                -- 右边生成2个小怪,向上移动
                 --左边生成三个小怪,并向下移动

                 for i = 1,2 do
                    local critter = THSTG.UI.newNode({
                        x = display.width - 40,
                        y = 0 - (i-1) * 60,
                        height = 40,
                        width = 40,
                        anchorPoint = THSTG.UI.POINT_RIGHT_TOP,
                    })
    
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



    --假设整个场景时长270,不一定按现实时间推进,也会因为对话框触发等待
    local SCENARIO_LENGTH = 270
    local SCHEDULE_TABLE = {}
    local _varLastHighTime = 0
    local function getSec10Tick()
        return THSTG.TimeUtil.getHighPrecisionTime()/100
    end

    local function push(initTime,callback)
        if type(callback) == "function" then
            SCHEDULE_TABLE[initTime] = SCHEDULE_TABLE[initTime] or {}
            table.insert( SCHEDULE_TABLE[initTime], callback )
        end
    end

    local function initInfo()
        for _,v in ipairs(FUNC_TABLE) do
            push(v.time,v.callback)
        end
        _varLastHighTime = getSec10Tick()
        
    end

    local function poll()
        --轮询
        local curTime = math.ceil(getSec10Tick() - _varLastHighTime)
        --由于精度关系,可能会跑4次
        -- print(15,curTime)
        local funsTb = SCHEDULE_TABLE[curTime]
        if funsTb then
            for i,v in ipairs(funsTb) do
                -- print(15,v)
                --XXX:应该弄一个队列,执行一次就从
                funsTb[i](curTime)
                funsTb[i] = nil
            end
            funsTb = nil
        end
    end

    local function updateFrame()
        poll()
    end

    node:onNodeEvent("enter", function ()
        initInfo()
        node:scheduleUpdateWithPriorityLua(updateFrame,0)
    end)

    node:onNodeEvent("exit", function ()
        node:unscheduleUpdate()
    end)



  

    return node
end

return M