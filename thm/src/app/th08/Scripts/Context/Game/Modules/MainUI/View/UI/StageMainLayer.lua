module(..., package.seeall)

--[[
    参数说明:

]]

local M = {}
function M.create(params)
    params = params or {}
    -------Model-------
    --TODO:
    --被弹数
    --得分
    --擦弹次数
    --生命
    --Bomb个数
   
    -------View-------
    local node = THSTG.UI.newNode()

    local function initLayer()
        --
    end

    local function initData()
        
    end

    local function init()
        initLayer()
        initData()
    end
    init()
    -------Controller-------
    node:onNodeEvent("enter", function ()
        -- Dispatcher.addEventListener(EventType.STAGE_SPELLCARD_EFFECT_WND, self._spellEffectWnd, self)
    end)

    node:onNodeEvent("exit", function ()
        -- Dispatcher.removeEventListener(EventType.STAGE_SPELLCARD_EFFECT_WND, self._spellEffectWnd, self)
    end)
    
    return node
end

return M