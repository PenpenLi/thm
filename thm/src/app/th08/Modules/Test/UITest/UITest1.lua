module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
    local SHEET_INFO = {
        {name = "rm_normal",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 4,rect = {x = 0,y = 0,width = 4*32,height = 48},time = 1/8},
        {name = "rm_move_left",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 7,rect = {x = 0,y = 48,width = 7*32,height = 48},time = 1/14},
        {name = "rm_move_left_start",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 2,rect = {x = 0,y = 48,width = 2*32,height = 48},time = 1/8},
        {name = "rm_move_left_sustain",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 5,rect = {x = 2*32,y = 48,width = 5*32,height = 48},time = 1/10},

        -- {name = "rm_speel_card1",source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),length = 1,rect = {x = 0,y = 3*48,width = 2*32,height = 16},time = 1/2},
    }
    local ANIMATION_TB = {}
    local _varKeyboardListener = nil

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

    local function moveUpDownHandle()
        -- sprite:stopAllActions()
        -- sprite:playAnimationForever(ANIMATION_TB["rm_normal"])
    end

    local function transfigurationHandle()

    end

    local function normalHandle(keyCode, event)
        --如果之前的动作就是正常状态,那么就不需要停止动作
        if keyCode == cc.KeyCode.KEY_W or keyCode == cc.KeyCode.KEY_S then
            return
        end

        local actions = {}
        if keyCode == cc.KeyCode.KEY_A or keyCode == cc.KeyCode.KEY_D then
            table.insert( actions,cc.Animate:create(ANIMATION_TB["rm_move_left"]):reverse())
            table.insert( actions,cc.CallFunc:create(function() 
                sprite:setFlippedX(not sprite:isFlippedX())
            end))
        end
        table.insert( actions,cc.CallFunc:create(function() 
            sprite:playAnimationForever(ANIMATION_TB["rm_normal"])
        end))

        sprite:stopAllActions()
        sprite:runAction(cc.Sequence:create(actions))

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
                moveUpDownHandle()
            elseif keyCode == cc.KeyCode.KEY_S then
                moveUpDownHandle()
            elseif keyCode == cc.KeyCode.KEY_Z then
                --攻击
            elseif keyCode == cc.KeyCode.KEY_X then
                --大招
            elseif keyCode == cc.KeyCode.KEY_C then
                --擦弹
            elseif keyCode == cc.KeyCode.KEY_SHIFT then
                transfigurationHandle()
                print(15,"Press Shift")
            end
        end,
        onReleased = function(keyCode, event)
            normalHandle(keyCode, event)
            print(15,"Release")
        end
    })

    node:onNodeEvent("enter", function ()
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varKeyboardListener, node)

	end)

	node:onNodeEvent("exit", function ()
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
    end)

    return node
end
return M