module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
    local SHEET_INFO = {
        {name = "rm_normal",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 4,rect = {x = 0,y = 0,width = 4*32,height = 48},time = 1/8},
        {name = "rm_move_left",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 7,rect = {x = 0,y = 48,width = 7*32,height = 48},time = 1/14},
        {name = "rm_move_left_start",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 2,rect = {x = 0,y = 48,width = 2*32,height = 48},time = 1/8},
        {name = "rm_move_left_sustain",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 5,rect = {x = 2*32,y = 48,width = 5*32,height = 48},time = 1/10},

        {name = "zm_normal",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 4,rect = {x = 4*32,y = 0,width = 4*32,height = 48},time = 1/8},
        {name = "zm_move_left",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 7,rect = {x = 0,y = 2*48,width = 7*32,height = 48},time = 1/8},
        {name = "zm_move_left_start",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 2,rect = {x = 0,y = 2*48,width = 2*32,height = 48},time = 1/8},
        {name = "zm_move_left_sustain",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 5,rect = {x = 2*32,y = 2*48,width = 5*32,height = 48},time = 1/8},

        -- {name = "rm_speel_card1",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 1,rect = {x = 0,y = 3*48,width = 2*32,height = 16},time = 1/2},
    }
    local ANIMATION_TB = {}
    local _varKeyboardListener = nil
    local _varTouchAllListener = nil
    --------View--------
    local node = THSTG.UI.newNode()
    local function createSheetAnimation(i)
        local info = SHEET_INFO[i]
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesBySheet({
                source = info.source,
                length = info.length,
                rect = info.rect,
            }),
            time = info.time
        })
        return animation
    end

    local function showAnimationEx()
        local oriFrameWidth = SHEET_INFO[1].rect.width/SHEET_INFO[1].length
        local oriFrameHeight = SHEET_INFO[1].rect.height
        
        local curFrameWidth = oriFrameWidth
        local curFrameHeight = oriFrameHeight
        local lastFrameWidth = oriFrameWidth
        local lastFrameHeight = oriFrameHeight

        local posX = -lastFrameWidth/2
        local posY = display.height - oriFrameHeight/2
        for i,v in ipairs(SHEET_INFO) do
            curFrameWidth = v.rect.width/v.length
            curFrameHeight = v.rect.height

            posX = posX + curFrameWidth/2 + lastFrameWidth/2
            if posX>= display.width then
                posX = curFrameWidth/2
                posY = posY - oriFrameHeight
            end

            local animation = createSheetAnimation(i)
            local sprite = THSTG.UI.newSprite({
                x = posX,
                y = posY,
                anchorPoint = THSTG.UI.POINT_CENTER,
                
            })
 
            local clickNode = THSTG.UI.newWidget({
                x = curFrameWidth/2,
                y = curFrameHeight/2,
                width = curFrameWidth,
                height = curFrameHeight,
                anchorPoint = THSTG.UI.POINT_CENTER,
                onClick = function()
                    dump(15,v.rect,v.name)
                end,
            })
            sprite:addChild(clickNode)
            
            sprite:playAnimationForever(animation)
            node:addChild(sprite)
            ANIMATION_TB[v.name] = animation

            

            lastFrameWidth = curFrameWidth
            lastFrameHeight = lastFrameHeight
        end
    end
    showAnimationEx()

    ---
    local sprite = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy-32,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    sprite:playAnimationForever(ANIMATION_TB["rm_normal"])
    node:addChild(sprite)

    -------
    local function moveLeftHandle()
        sprite:setFlippedX(false)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(ANIMATION_TB["rm_move_left_start"]),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(cc.Animate:create(ANIMATION_TB["rm_move_left_sustain"])))
            end)
        }))

    end

    local function moveRightHandle()
        sprite:setFlippedX(true)
        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create({
            cc.Animate:create(ANIMATION_TB["rm_move_left_start"]),
            cc.CallFunc:create(function() 
                -- sprite:stopAllActions()
                sprite:runAction(cc.RepeatForever:create(cc.Animate:create(ANIMATION_TB["rm_move_left_sustain"])))
            end)
        }))
    end

    local function normalHandle()

    end
   -------
    _varKeyboardListener = THSTG.EVENT.newKeyboardListener({
        --动画应该放入Cache中,不然回调时对象已经被释放-
        --可以用retain()增加引用
        onPressed = function (keyCode, event)
            if keyCode == cc.KeyCode.KEY_A then
                moveLeftHandle()
            elseif keyCode == cc.KeyCode.KEY_D then
                moveRightHandle()
            elseif keyCode == cc.KeyCode.KEY_W then
         
            elseif keyCode == cc.KeyCode.KEY_S then
               
            elseif keyCode == cc.KeyCode.KEY_Z then

            elseif keyCode == cc.KeyCode.KEY_X then

            elseif keyCode == cc.KeyCode.KEY_C then
                
            elseif keyCode == cc.KeyCode.KEY_SHIFT then
                print(15,"Press Shift")
            end
        end,
        onReleased = function(keyCode, event)
            
           

            -- local animate = cc.Animate:create(leftAnimation):reverse()
            -- animate:reverse()
            
            local actions = {}
            if keyCode == cc.KeyCode.KEY_A or keyCode == cc.KeyCode.KEY_D then
                table.insert( actions,cc.Animate:create(ANIMATION_TB["rm_move_left"]):reverse())
                table.insert( actions,cc.CallFunc:create(function() 
                    sprite:setFlippedX(not sprite:isFlippedX())
                end))
            end
            table.insert( actions,cc.CallFunc:create(function() 
                -- sprite:stopAllActions()   
                sprite:playAnimationForever(ANIMATION_TB["rm_normal"])
            end))
    
            --TODO:如果之前的动作就是正常状态,那么就不需要停止动作
            sprite:stopAllActions()
            sprite:runAction(cc.Sequence:create(actions))
           
            print(15,"Release")
        end
    })

    --
    local function getMsTime()
        local socket = require "socket"
        return socket.gettime() * 1000

    end
    local lastClickTime = 0

    local moveCount = 0
    local lastMoveState = {pos = cc.p(0,0),time = 0,shift = cc.p(0,0)}

    _varTouchAllListener = THSTG.EVENT.newTouchAllAtOnceListener({
        onBegan = function(touches, event)
            
            --点击计数，在400ms内如果点击两次认为是双击
            --最后一次减去倒数第二次的时间间隔小于400ms
            local curClickTime = getMsTime()
            local isDouble = curClickTime - lastClickTime <= 400
            if isDouble then
                print(15,"双击")
            end
            lastClickTime = curClickTime

            return true
        end,
        onMoved = function(touches, event)
            if #touches > 1 then
                -- print(15,"双指移动")
            else
                -- print(15,"单指移动")
            end


            --TODO:是否来回抖动
            --只当速度开始剧烈变化时计时开始
            --连续三次改变方向,第一次改变方向开始计时
            --或者加速度连续三次为0
            -- local curClickTime = getMsTime()
            local curPos = touches[1]:getLocation()
            local curTime = getMsTime()
            
            local dTime = curTime - lastMoveState.time
            if dTime > 50 then --取样频度
                local curShift = cc.pSub(curPos,lastMoveState.pos)
                local angle = cc.pGetAngle(curShift,lastMoveState.shift)
                local speed = cc.pGetLength(curShift) / dTime * 100
                
                --
              
                --法一:连续3次改变速度方向
                -- if angle*180/3.1415 >=90 then
                --     print(15,angle*180/3.1415)
                -- end

                --法二:连续500ms速度大于90
                -- print(15,speed)
                if speed >= 200 then
                    if lastMoveState.speedCheck then
                        local dTime = curTime - lastMoveState.speedCheck.startTime 
                        if dTime <= 100 then--连续500ms速度大于90
                            print(15,"抖动")
                            lastMoveState.speedCheck = nil
                        end
                    else
                        lastMoveState.speedCheck = {}
                        lastMoveState.speedCheck.startTime = curTime
                    end
                else
                    lastMoveState.speedCheck = nil
                end

                --
                lastMoveState.pos = curPos
                lastMoveState.time = curTime
                lastMoveState.shift = curShift
            end
        end,
        onEnded = function(touches, event)
            local curClickTime = getMsTime()
            local isLongClick = curClickTime - lastClickTime >= 1000
            if isLongClick then
                print(15,"长按")
            end

            -- print(15,"释放")

        end,
    })

    node:onNodeEvent("enter", function ()
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varKeyboardListener, node)
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varTouchAllListener, node)
	end)

	node:onNodeEvent("exit", function ()
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
        THSTG.CCDispatcher:removeEventListener(_varTouchAllListener)
    end)

    return node
end
return M