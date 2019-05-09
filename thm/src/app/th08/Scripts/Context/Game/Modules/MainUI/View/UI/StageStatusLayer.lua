module(..., package.seeall)

--[[
    参数说明:

]]

local M = {}
function M.create(params)
    params = params or {}
    -------Model-------
    local _uiEntityLb = nil

   
    -------View-------
    local node = THSTG.UI.newNode()

    local function initLayer()
        local vBox = THSTG.UI.newVBox({
            x = 0,
            y = display.height,
            anchorPoint = THSTG.UI.POINT_LEFT_TOP,
            margin = 0,
            autoSize = true,
            linearGravity = ccui.LinearGravity.centerVertical
        })
        node:addChild(vBox)
        
        _uiEntityLb = THSTG.UI.newLabel()
        vBox:addChild(_uiEntityLb)


        vBox:forceDoLayout()
    end

    local function initData()
        
    end

    local function init()
        initLayer()
        initData()
    end
    init()
    -------Controller-------
    function node:updateData(e,params)
        _uiEntityLb:setText(string.format( "EnemyCount:%d",10))
    end

    node:onNodeEvent("enter", function ()
        Dispatcher.addEventListener(EventType.STAGE_TEST_STATUS_UPDATE, node.updateData, node)
    end)

    node:onNodeEvent("exit", function ()
        Dispatcher.removeEventListener(EventType.STAGE_TEST_STATUS_UPDATE, node.updateData, node)
    end)
    
    return node
end

return M