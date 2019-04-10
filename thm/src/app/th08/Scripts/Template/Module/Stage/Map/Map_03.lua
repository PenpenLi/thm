module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    -- THSTG.AudioManager.playMusic(SoundConfig.getFilePath(100121))
   
    -------View-------
    local node = THSTG.UI.newNode()
    local music = THSTG.AUDIO.newMusic({
        src = SoundConfig.getFilePath(100101),
    })
    
    local mainBg = UIPublic.newUVRollSprite({
        x = display.cx,
        y = display.cy,
        width = display.width-100,
        height = display.height,
        anchorPoint = THSTG.UI.POINT_CENTER,
        source = {TexType.SHEET,"stg1bg","stg01_bg"},
        uniforms = {
            speedX = 0.01,
            speedY = -0.1,
            vRange = cc.p(0,0.5),
        },
    })
    mainBg:setRotation3D(cc.vec3(120,0,0))
    node:addChild(mainBg)
  
    -------Controller-------
    node:onNodeEvent("enter", function ()
        music:play()
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M