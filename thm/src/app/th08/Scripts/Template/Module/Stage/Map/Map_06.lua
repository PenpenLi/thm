module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
   
   
    -------View-------
    local node = THSTG.UI.newNode()
    local skyBg = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        width = 2*display.width,
        height = 2*display.height,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getModuleRes(ModuleType.STAGE, "stg1_sky"),
    })
    skyBg:setRotation3D(cc.vec3(0,0,0))
    skyBg:runAction(cc.RotateBy:create(4, {x = 60, y = 0, z = 0}))        --做一个翻转动画
    -- node:addChild(skyBg)

    local mainBg = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy-200,
        width = 2*display.width,
        height = 2*display.height,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getModuleRes(ModuleType.STAGE, "stg1_sea"),
        isTile = true,
    })
    mainBg:setRotation3D(cc.vec3(-80,0,0))
    mainBg:runAction(cc.RotateBy:create(4, {x = 60, y = 0, z = 0}))        --做一个翻转动画
    node:addChild(mainBg)

    --启用一个uv动画Shader
    local waveShader = THSTG.UI.newShader({
        fsSrc = ResManager.getRes(ResType.SHADER, "f_uvWave"),
        uniform = {
            _speed = 10.0,
            _scale = 1.0,
            _identity = 80.0
        }
    })
    waveShader:effect(mainBg)
    
    -------Controller-------
    node:onNodeEvent("enter", function ()

    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M