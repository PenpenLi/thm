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
    --帧拆解
    local leftAnimation_start = THSTG.SCENE.newAnimation({
        frames = THSTG.SCENE.newFramesBySheet({
            source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),
            length = 2,
            rect = {x = 0,y = 48,width = 2*32,height = 48}
        }),
        time = 1/14
    })

    local leftAnimation_left = THSTG.SCENE.newAnimation({
        frames = THSTG.SCENE.newFramesBySheet({
            source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),
            length = 5,
            rect = {x = 2*32,y = 48,width = 5*32,height = 48}
        }),
        time = 1/14
    })




    --应该有一种反向的吧,生成Animate然后反向
    local leftAnimation_res = THSTG.SCENE.newAnimation({
        frames = THSTG.SCENE.newFramesBySheet({
            source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),
            length = 7,
            rect = {x = 0,y = 48,width = 7*32,height = 48},
            isReversed = true,
        }),
        time = 1/14
    })
  
    ---
   
    local sprite = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy-32,
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

    local sprite3 = THSTG.UI.newSprite({
        x = display.cx+64,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    sprite3:playAnimationForever(leftAnimation_res)
    node:addChild(sprite3)

    local sprite4 = THSTG.UI.newSprite({
        x = display.cx-64,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    sprite4:playAnimationForever(leftAnimation_start)
    node:addChild(sprite4)

    local sprite5 = THSTG.UI.newSprite({
        x = display.cx-96,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    sprite5:playAnimationForever(leftAnimation_left)
    node:addChild(sprite5)



   -------
    _varKeyboardListener = THSTG.EVENT.newKeyboardListener({
        --TODO:动画应该放入Cache中,不然回调时对象已经被释放
        onPressed = function (keyCode, event)
            if keyCode == cc.KeyCode.KEY_A then
                sprite:setFlippedX(false)
                sprite:stopAllActions()
                sprite:runAction(cc.Sequence:create({
                    cc.Animate:create(leftAnimation_start),
                    cc.CallFunc:create(function() 
                        -- sprite:stopAllActions()
                        sprite:runAction(cc.RepeatForever:create(cc.Animate:create(leftAnimation_left)))
                    end)
                }))


                -- sprite:playAnimationOnce(leftAnimation,{})
                print(15,"Press")
            elseif keyCode == cc.KeyCode.KEY_D then
                sprite:setFlippedX(true)
                sprite:stopAllActions()
                sprite:runAction(cc.Sequence:create({
                    cc.Animate:create(leftAnimation_start),
                    cc.CallFunc:create(function() 
                        -- sprite:stopAllActions()
                        sprite:runAction(cc.RepeatForever:create(cc.Animate:create(leftAnimation_left)))
                    end)
                }))
            end
        end,
        onReleased = function(keyCode, event)
            
            sprite:stopAllActions()

            -- local animate = cc.Animate:create(leftAnimation):reverse()
            -- animate:reverse()

            sprite:runAction(cc.Sequence:create({
				cc.Animate:create(leftAnimation):reverse(),
                cc.CallFunc:create(function() 
                    
                    sprite:setFlippedX(false)
                    sprite:stopAllActions()
                    sprite:playAnimationForever(normalAnimation)
                end)
            }))
           
            -- sprite:playAnimationOnce(leftAnimation_res,{
            --     onComplete = function()
            --         sprite:stopAllActions()
            --         sprite:playAnimationForever(normalAnimation)
            --     end
            -- })
            --TODO:进入的时候居然执行这个
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