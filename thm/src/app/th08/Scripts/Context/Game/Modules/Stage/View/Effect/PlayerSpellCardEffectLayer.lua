module(..., package.seeall)

--[[
    参数说明:

]]

local M = {}
function M.create(params)
    params = params or {}

    -------Model-------
    local _uiEffect = nil
   
    -------View-------
    local node = THSTG.UI.newNode()

    local function initLayer()
        --背景黑幕
        local maskNode = THSTG.UI.newLayerColor({
            color = {r=0,g=0,b=0},
            opacity = 0.5,
        })
        node:addChild(maskNode)

        --特效
        _uiEffect = GlobalUtil.playEffect({
            x = display.cx,
            y = display.cy,
            src = ResManager.getResMul(ResType.ANIMATION,AnimationType.SKELETON,"spine_dragonborn_logo"),
            isLoop = false,
            scale = 0.4,
            father = node,
            onComplete = function(sender)
                THSTG.Dispatcher.dispatchEvent(EventType.STAGE_SPELLCARD_EFFECT_WND,{isPlayer = true,isOpen = false})
            end,
        })
    end

    local function initData()
        _uiEffect:playAnimation(0,"newAnimation")
        --生成一个动画并运行
        --关闭特效窗口
        -- 
    end

    local function init()
        initLayer()
        initData()
    end
    init()
    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M