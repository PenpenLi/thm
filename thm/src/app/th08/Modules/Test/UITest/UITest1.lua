module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
   

    --------View--------
    local node = THSTG.UI.newNode()

    local frames = THSTG.SCENE.newFramesBySheet({
        source = ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),
        length = 4,
        rect = {x = 0,y = 0,width = 128,height = 48}
    })
    local animation = THSTG.SCENE.newAnimation({frames = frames})

    local sprite = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    sprite:playAnimationForever(animation)
    node:addChild(sprite)

   -------
    node:onNodeEvent("enter", function ()
        
	end)

	node:onNodeEvent("exit", function ()
        
    end)

    return node
end
return M