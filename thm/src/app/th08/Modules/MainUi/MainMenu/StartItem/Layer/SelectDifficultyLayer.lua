local M = {}

function M.create(params)
    params = params or {}
    local _onClick = params.onClick

    --------Model--------
    local _uiTitle = nil
    local _uiTitleList = nil

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

    local _uiTitle = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy * 2,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getRes(ResType.MAIN_UI,"diff_title"),
    })
    node:addChild(_uiTitle)

    --TODO:这个控件由于存在宽高,导致边界的存在
    _uiTitleList = THSTG.UI.newTileList({
        x = display.cx,
        y = display.cy * 2 - 80,
        width = 950, 
        height = 535, 
        anchorPoint = THSTG.UI.POINT_CENTER_TOP,
        colCount = 1,
        itemColGap = 10,
        bounceEnabled = false,

        isOnChange = true,
        -- padding = {left= 0,right=0,top=0,bottom =5},
        direction = ccui.ListViewDirection.vertical,
        itemTemplate = createTemplate,
        onSelectedIndexChange = function (sender,selectedNode, selectedPos, lastNode, lastPos)
            return _selectedChangedHandle(sender,selectedNode, selectedPos, lastNode, lastPos)
        end,
    })
    node:addChild(_uiTitleList)

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
        _uiTitle:runAction(cc.MoveBy:create(0.1, cc.p(0,-40)))
        _uiTitleList:setDataProvider(SelectDiffConfig.getInfos())
        _uiTitleList:setSelected(1)
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