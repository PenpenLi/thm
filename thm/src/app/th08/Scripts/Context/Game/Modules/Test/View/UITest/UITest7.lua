module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
   
    -------View-------
    local node = THSTG.UI.newNode()


    
    -- local skeletonNode = THSTG.ANIMATION.newSpineAnimation({
    --     x = display.cx,
    --     y = display.cy,
    --     src = ResManager.getRes(ResType.ANIMATION,AnimaType.TWEEN,"spine_dragonborn_logo"),
    --     default = "newAnimation",
    -- })
    -- skeletonNode:setScale(0.4)
    -- node:addChild(skeletonNode)

    local sp0 = GlobalUtil.playEffect({
        x = display.cx,
        y = display.cy,
        src = ResManager.getRes(ResType.ANIMATION,AnimaType.TWEEN,"spine_boss_spellcard_attack"),
        animation = "default",
        isLoop = false,
        scale = 0.4,
        father = node,
    })

    local tail = THSTG.UI.newMotionStreak({
        x = 0,
        y =0,
        src = "Assets/UI/Loading/loading_icon_1.png"
    })
    tail:runAction(cc.MoveTo:create(8.0,cc.p(600,600)))
    node:addChild(tail)
   
    

    local p1 = THSTG.EFFECT.newParticleSystem({
        x = display.width/2,
        y = display.height/2,
        anchorPoint = cc.p(0.5,0.5),
        isLoop = true,
        src = ResManager.getRes(ResType.SFX,SFXType.PARTICLE,"ccp_gk_leaf"),
    })
    p1:play()
    node:addChild(p1)

    local p2 = THSTG.EFFECT.newParticleSystem({
        x = display.width/2,
        y = display.height/2,
        anchorPoint = cc.p(0.5,0.5),
        isLoop = true,
        src = ResManager.getRes(ResType.SFX,SFXType.PARTICLE,"ccp_gk_protected"),
    })
    node:addChild(p2)

    node:runAction(cc.Sequence:create({
        cc.DelayTime:create(3.0),
        cc.CallFunc:create(function()
            p2:stop()
        end),
        cc.DelayTime:create(3.0),
        cc.CallFunc:create(function()
            p2:play()
        end)
    }))
    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node
end

return M