module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------

   
    -------View-------
    local node = THSTG.UI.newNode()

    local music = THSTG.AUDIO.newMusic({
        src = SoundConfig.getFilePath(100101),
    })


    local mainBg = UIPublic.newUVRollSprite({
        x = display.cx,
        y = display.cy,
        width = display.width,
        height = display.height,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getRes(ResType.TEXTURE,TexType.IMAGE,"stg1bg"),
        isTile = true,
        uniforms = {
            speedX = 0,
            speedY = -1,
        },
    })
    node:addChild(mainBg)
  
    -------Controller-------
    node:onNodeEvent("enter", function ()
        -- music:play()
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M