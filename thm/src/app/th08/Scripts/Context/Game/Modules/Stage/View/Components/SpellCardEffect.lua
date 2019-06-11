local M = {}

function M.create(params)
    params = params or {}
    -------Model-------
    local uiMainAnimation = false
   
    -------View-------
    local node = THSTG.UI.newNode()
    uiMainAnimation = THSTG.ANIMATION.newSpineAnimation({
        x = display.cx,
        y = display.cy,
        src = ResManager.getRes(ResType.ANIMATION,AnimaType.TWEEN,"spine_boss_spellcard_attack"),
    })
    uiMainAnimation:setScale(0.4)
    node:addChild(uiMainAnimation)

    local function init()
     
    end
    init()
    -------Controller-------
    node:onNodeEvent("enter", function ()
       
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    function node:play(params)
        local entityType = params.entityData:getEntityType()
        local isDeadSave = params.isDeadSave
        print(15,entityType)
        if isDeadSave then
            print(15,"决死特效")
        end
        uiMainAnimation:playAnimation(0,"default",false)
    end

    return node
end

return M