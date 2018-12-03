local M = {}

function M.create(params)
    params = params or {}
    --------Model--------
   

    local _ui = {}
    _ui.title = nil
    _ui.tileList = nil
    _ui.diffNodes = {}

    local _varSelectedNode = nil
    local _varKeyboardListener = nil
    local _varAcitonsPos = {}
    local _varIsEnabled = true

    local _selectedChangedHandle = nil

    --------View--------
    local function createTemplate()
        local _data = nil
        local node = THSTG.UI.newWidget({
            width = 256,
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

            local newPos = cc.p(self:getPositionX()  + data.offsetPos.x ,self:getPositionY()  + data.offsetPos.y )
            self:setPosition(newPos)


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

    

    _ui.tileList = UI.newAdapterList({--THSTG.UI.newTileList({
        x = display.cx,
        y = display.cy * 2 - 50,
        width = display.width,
        height = display.height - 50,
        anchorPoint = THSTG.UI.POINT_CENTER_TOP,
        colCount = 1,
        itemColGap = 10,
        bounceEnabled = false,

        isOnChange = true,
        direction = ccui.ListViewDirection.vertical,
        itemTemplate = createTemplate,
        onSelectedIndexChange = function (sender,selectedNode, selectedPos, lastNode, lastPos)
            return _selectedChangedHandle(sender,selectedNode, selectedPos, lastNode, lastPos)
        end,
    })
    node:addChild(_ui.tileList)

    --------Control--------
   
    local function selectMoveAction()
        local nodes = _ui.tileList:getNodes()
        for i,v in ipairs(nodes) do
            local destPos = nil
            -- _varAcitonsPos[i] = cc.p(v:getPosition())
            if v == _varSelectedNode then
                destPos = cc.p(v:getContentSize().width/2,v:getContentSize().height/2) --移动到左下角
            else
                local offsetX = i%2 == 0 and display.width + v:getContentSize().width or -v:getContentSize().width
                destPos = cc.p(offsetX,v:getPositionY())
            end
            local moveAction = cc.MoveTo:create(0.3,destPos)
            v:runAction(moveAction)
        end
        
    end

    local function cancelMoveAction()
        local nodes = _ui.tileList:getNodes()
        for i,v in ipairs(nodes) do
            local destPos = _varAcitonsPos[i]
            local moveAction = cc.MoveTo:create(0.3,destPos)
            v:runAction(moveAction)
        end
    end
    _selectedChangedHandle = function(sender,selectedNode, selectedPos, lastNode, lastPos)
        if selectedPos == lastPos then
            _varSelectedNode = selectedNode
            selectMoveAction()
            THSTG.Dispatcher.dispatchEvent(EventType.STARTITEM_SELECTDIFF_SELECT,{node = selectedNode,pos = selectedPos})

        else
            if selectedNode then selectedNode:setSelect(true) end
            if lastNode then lastNode:setSelect(false) end
        end
    end

    function node.updateLayer()
        local infos = Cache.selectionCache.getDiffSelInfos()
        _ui.tileList:setDataProvider(infos)
        _ui.tileList:setSelected(1)
        for i,v in ipairs(_ui.tileList:getNodes()) do
            _varAcitonsPos[i] = cc.p(v:getPosition())
        end
    end
    ---
    _varKeyboardListener = THSTG.EVENT.newKeyboardListener({
        onPressed = function (keyCode, event)
            if _varIsEnabled then
                if keyCode == cc.KeyCode.KEY_ESCAPE then
                    THSTG.Dispatcher.dispatchEvent(EventType.STARTITEM_SELECTDIFF_CANCEL)
                end
            end
        end,
    })
   
    function node.updateData(_,e,params)
        if e == EventType.STARTITEM_SELECTROLE_CANCEL then
            cancelMoveAction()
        end
    end

    function node:setEnabled(status)
        _varIsEnabled = status
        
    end

    node:onNodeEvent("enter", function ()
        node.updateLayer()
        THSTG.Dispatcher.addEventListener(EventType.STARTITEM_SELECTROLE_CANCEL,node.updateData)
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varKeyboardListener, node)
    end)

    node:onNodeEvent("exit", function ()
        THSTG.Dispatcher.removeEventListener(EventType.STARTITEM_SELECTROLE_CANCEL,node.updateData)
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
    end)

    
    return node
end

return M