module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local _uiStatusLb = false
    local _varEntityCount = 0
    -------View-------
    local node = THSTG.UI.newNode({
        width = display.width,
        height = display.height,
    })

    _uiStatusLb = THSTG.UI.newLabel({
        x = 0,
        y = node:getContentSize().height,
        text = Language.getString(201000,0),
        anchorPoint = THSTG.UI.POINT_LEFT_TOP,
        style = {
            color = THSTG.UI.getColorHtml('#ab1111'),
            size = THSTG.UI.FONT_SIZE_SMALL,
        }
    })
    node:addChild(_uiStatusLb)

    -------Controller-------
    function node.updateLayer(_,e,params)
        if e == EventType.STAGE_ADD_ENTITY or e == EventType.STAGE_REMOVE_ENTITY then
            if e == EventType.STAGE_ADD_ENTITY then _varEntityCount = _varEntityCount + 1 
            else _varEntityCount = _varEntityCount - 1 
            end
            _uiStatusLb:setText(Language.getString(201000,_varEntityCount))
        end
    end

    node:onNodeEvent("enter", function ()
        Dispatcher.addEventListener(EventType.STAGE_ADD_ENTITY, node.updateLayer)
        Dispatcher.addEventListener(EventType.STAGE_REMOVE_ENTITY, node.updateLayer)
    end)

    node:onNodeEvent("exit", function ()
        Dispatcher.removeEventListener(EventType.STAGE_ADD_ENTITY, node.updateLayer)
        Dispatcher.removeEventListener(EventType.STAGE_REMOVE_ENTITY, node.updateLayer)
    end)

    return node
end

return M