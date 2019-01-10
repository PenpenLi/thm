module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
   
    -------View-------
    local node = THSTG.UI.newNode()


    
    local skeletonNode = THSTG.UI.newSkeletonAnimation({
        x = display.cx,
        y = display.cy,
        src = ResManager.getResMul(ResType.ANIMATION,AnimationType.SKELETON,"spine_player_dragon"),
        default = "stand",
    })
   
    skeletonNode:setScale(0.4)
    node:addChild(skeletonNode)

    local p1 = THSTG.UI.newParticleSystem({
        x = display.width/2,
        y = display.height/2,
        anchorPoint = cc.p(0.5,0.5),
        isLoop = true,
        src = ResManager.getResMul(ResType.SFX,SFXType.PARTICLE,"ccp_gk_heart_01"),
    })
    node:addChild(p1)
    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node
end

return M