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

    -- local mainBg = UIPublic.newUVRollSprite({
    --     x = display.cx,
    --     y = display.cy,
    --     width = display.width,
    --     height = display.height,
    --     anchorPoint = THSTG.UI.POINT_CENTER,
    --     src = ResManager.getResSub(ResType.TEXTURE,TexType.IMAGE,"eff03b"),
    --     isTile = true,
    --     uniforms = {
    --         speedX = -2,
    --         speedY = -1,
    --     },
    -- })

    local mainBg = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        width = display.width,
        height = display.height,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getResSub(ResType.TEXTURE,TexType.IMAGE,"eff03b"),
        isTile = true
    })
    
    --启用一个uv动画Shader
    THSTG.NodeUtil.applyShader(mainBg,{
        shaderKey = "f_uvRoll",
        fsSrc = ResManager.getRes(ResType.SHADER,"f_uvRoll"),
        uniform = {
            _speedX = -1,
            _speedY = -2,
            _uRange = {x = 0, y = 1} ,
            _vRange = {x = 0, y = 1} ,
        }
    })
    node:addChild(mainBg)


    --------
    -- local mainBg = UIPublic.newUVWaveSprite({
    --     x = display.cx,
    --     y = display.cy + 100,
    --     width = 2*display.width,
    --     height = 2*display.height,
    --     anchorPoint = THSTG.UI.POINT_CENTER,
    --     src = "Assets/UI/Stage/Map/stg4_1_f.png",
    --     isTile = true,
    --     uniforms = {
    --         speed = 10,
    --         identity = 50,
    --     },
    -- })
    -- mainBg:setRotation3D(cc.vec3(-40,0,0))
    -- node:addChild(mainBg)

    -- THSTG.SCENE.loadPlistFile(ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"loading"))
    -- local sprite = THSTG.UI.newSprite({
    --     x = display.cx,
    --     y = display.cy ,
    --     anchorPoint = THSTG.UI.POINT_CENTER,
    --     src = "#loading_03"
    -- })
    -- node:addChild(sprite)

    -- THSTG.ANIMATION.DBXManager.loadDBXFile(
    --     ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),
    --     ResManager.getResSub(ResType.ANIMATION,AnimType.SEQUENCE,"reimu_base_ani")
    -- )
    -- local anime = THSTG.ANIMATION.DBXManager.createAnime("reimu_base_ani","idle")
    -- local tex = THSTG.ANIMATION.DBXManager.createTexture("player00","reimu_idle_01")
  
    -- local sprite = cc.Sprite:createWithTexture(tex)
    -- sprite:setPosition(cc.p(display.cx,display.cy))
    -- sprite:runAction(anime)
    -- node:addChild(sprite)
    -------Controller-------
    node:onNodeEvent("enter", function ()
        -- music:play()
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M