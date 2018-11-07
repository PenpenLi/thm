module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
   
    local _varKeyboardListener = nil
    --------View--------
    local node = THSTG.UI.newNode()

    local normalAnimation = THSTG.SCENE.newAnimation({
        frames = THSTG.SCENE.newFramesBySheet({
            source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),
            length = 4,
            rect = {x = 0,y = 0,width = 128,height = 48}
        }),
        time = 1/8
    })

    local leftAnimation = THSTG.SCENE.newAnimation({
        frames = THSTG.SCENE.newFramesBySheet({
            source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),
            length = 7,
            rect = {x = 0,y = 48,width = 7*32,height = 48}
        }),
        time = 1/14
    })
  
    ---
   
    local sprite = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    sprite:playAnimationForever(normalAnimation)
    node:addChild(sprite)

    local sprite1 = THSTG.UI.newSprite({
        x = display.cx-32,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    sprite1:playAnimationForever(normalAnimation)
    node:addChild(sprite1)

    local sprite2 = THSTG.UI.newSprite({
        x = display.cx+32,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    sprite2:playAnimationForever(leftAnimation)
    node:addChild(sprite2)

   -------
    _varKeyboardListener = THSTG.EVENT.newKeyboardListener({
        onPressed = function (keyCode, event)
            if keyCode == cc.KeyCode.KEY_A then
                sprite:setFlippedX(false)
                sprite:stopAllActions()
                sprite:playAnimationOnce(leftAnimation,{})
                print(15,"Press")
            elseif keyCode == cc.KeyCode.KEY_D then
                sprite:setFlippedX(true)
                sprite:stopAllActions()
                sprite:playAnimationOnce(leftAnimation,{})
            end
        end,
        onReleased = function(keyCode, event)
            sprite:setFlippedX(false)
            sprite:stopAllActions()
            sprite:playAnimationForever(normalAnimation)
            print(15,"Release")
        end
    })

    node:onNodeEvent("enter", function ()
        THSTG.CCDispatcher:addEventListenerWithFixedPriority(_varKeyboardListener, 1)
	end)

	node:onNodeEvent("exit", function ()
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
    end)

    return node
end
return M