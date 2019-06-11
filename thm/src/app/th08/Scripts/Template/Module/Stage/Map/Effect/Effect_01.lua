local M = {}
function M.create(params)
    -------Model-------

   
    -------View-------
    local node = THSTG.UI.newNode()

    local mainBg = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        width = display.width,
        height = display.height,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getModuleRes(ModuleType.STAGE,"eff03b"),
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
    -------Controller-------
    node:onNodeEvent("enter", function ()

    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M