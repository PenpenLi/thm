module(..., package.seeall)

local M = {}
function M.create(params)
    params = params or {}
    -------Model-------
    local _uiEffect = nil
   
    -------View-------
    local node = THSTG.UI.newNode()
    node:setVisible(false)


    local function initLayer()
          --特效
          _uiEffect = THSTG.ANIMATION.newSpineAnimation({
            x = display.cx,
            y = display.cy,
            src = ResManager.getResMul(ResType.ANIMATION,AnimationType.TWEEN,"spine_boss_spellcard_attack"),
            onComplete = function(sender)
                node:setVisible(false)
            end,
        })
        _uiEffect:setScale(0.4)
        node:addChild(_uiEffect)
    end
    

    local function initData()
        --生成一个动画并运行
        
    end

    local function init()
        initLayer()
        initData()
    end
    init()
    -------Controller-------
    function node:show()

        
        self:setVisible(true)
    end

    local function updateLayer(_,e,params)
        if tolua.isnull(node) then
            return 
        end
        
        local isDeadSave = params.isDeadSave
        if not isDeadSave then return end   --非决死复活没有特效

        _uiEffect:setAnimation(0,"default",false)
        node:show()
    end

    node:onNodeEvent("enter", function ()
        Dispatcher.addEventListener(EventType.STAGE_PLAYER_SPELLCARD_ATTACK, updateLayer)
    end)

    node:onNodeEvent("exit", function ()
        Dispatcher.removeEventListener(EventType.STAGE_PLAYER_SPELLCARD_ATTACK, updateLayer)
    end)
    
    return node
end

return M