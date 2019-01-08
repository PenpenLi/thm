module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
   
    -------View-------
    local node = THSTG.UI.newNode()

    local p1 = THSTG.UI.newParticle({
        x = display.width/2,
        y = display.height/2,
        anchorPoint = cc.p(0.5,0.5),
        isLoop = true,
        src = ResManager.getResSub(ResType.PARTICLE,ParticleType.PUBLIC,"ccp_gk_heart_01"),
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