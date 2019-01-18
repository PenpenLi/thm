module(..., package.seeall)

--[[
    参数说明:

]]

local M = {}
function M.create(params)
    params = params or {}

    -------Model-------

   
    -------View-------
    local node = THSTG.UI.newNode()

    local function initLayer()
        --背景黑幕
        local maskNode = THSTG.UI.newMaskLayer({
            alpha = 0.5,
        })
        node:addChild(maskNode)

        --特效
    end

    local function initData()
        --生成一个动画并运行
        --关闭特效窗口
        -- THSTG.Dispatcher.dispatchEvent(EventType.STAGE_SPELLCARD_EFFECT_WND,{isPlayer = true,isOpen = false})
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