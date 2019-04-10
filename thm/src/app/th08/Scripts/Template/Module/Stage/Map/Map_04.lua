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
    
    local mainBg = UIPublic.newUVWaveSprite({
        x = display.cx,
        y = display.cy + 100,
        width = 2*display.width,
        height = 2*display.height,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = "Assets/Module/Stage/Map/stg4_1_f.png",
        isTile = true,
        uniforms = {
            speed = 10,
            identity = 50,
        },
    })
    mainBg:setRotation3D(cc.vec3(-40,0,0))
    -- node:addChild(mainBg)
  
    -------Controller-------
    node:onNodeEvent("enter", function ()
        music:play()
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M