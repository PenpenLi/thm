local M = {}

function M.create(params)
    params = params or {}
    local _onClick = params.onClick

    --------Model--------
    local _ui = {}
    _ui.title = nil
    _ui.tileList = nil
    _ui.diffNodes = {}

    local _selectedChangedHandle = nil

    --------View--------
    local function createTemplate()
        local _data = nil
        local node = THSTG.UI.newWidget({
            width = 556,
            height = 80,
        })
        
        local title = THSTG.UI.newImage({
            x = node:getContentSize().width/2,
            y = node:getContentSize().height/2,
            anchorPoint = THSTG.UI.POINT_CENTER,
        })
        node:addChild(title)

        function node:setState(data,pos)
            _data = data

            title:setSource(data.onSrc)

            local newPos = cc.p(title:getPositionX()  + data.offsetPos.x ,title:getPositionY()  + data.offsetPos.y )
            title:setPosition(newPos)

            self:setSelect(data.__isClick)
        end


        function node:setSelect(status)
            if status == true then
                title:setSource(_data.onSrc)
                title:runAction(cc.MoveBy:create(0.1, cc.p(_data.moveBy.x,_data.moveBy.y)))
            else
                title:setSource(_data.offSrc)
                title:runAction(cc.MoveBy:create(0.1, cc.p(-_data.moveBy.x,-_data.moveBy.y)))
            end
        end

        return node
    end
    local node = THSTG.UI.newNode()

    _ui.title = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy * 2,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getRes(ResType.MAIN_UI,"diff_title"),
    })
    node:addChild(_ui.title)

    local diffInfos = SelectDiffConfig.getInfos()
    for _,v in ipairs(diffInfos) do
        local node = createTemplate()
        --TODO:


    end
   

    --------Control--------
    _selectedChangedHandle = function(sender,selectedNode, selectedPos, lastNode, lastPos)
        if selectedPos == lastPos then

            if _onClick then
                _onClick(selectedNode)
            end
            
        else
            if selectedNode then selectedNode:setSelect(true) end
            if lastNode then lastNode:setSelect(false) end
        end
    end

    function node.updateLayer()
        _ui.title:runAction(cc.MoveBy:create(0.1, cc.p(0,-40)))

    end
    ---


    node:onNodeEvent("enter", function ()
        node.updateLayer()
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node
end

return M