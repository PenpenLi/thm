module(..., package.seeall)

local M = {}
THSTG.SCENE.loadPlistFile(ResManager.getResSub(ResType.TEXTURE,TexType.PLIST,"select_diff"))

function M.create(params)
    --------Model--------
    local _uiTitleList = nil

    local _selectedChangedHandle = nil
    --------View--------
    local function createTemplate()
        local node = THSTG.UI.newWidget({
            width = 256,
            height = 80,
        })

        local title = THSTG.UI.newSprite({
            x = node:getContentSize().width/2,
            y = node:getContentSize().height/2,
            anchorPoint = THSTG.UI.POINT_CENTER,
        })
        node:addChild(title)

        function node:setState(data,pos)
            title:setSource(data.onSrc)

            --只是选中,并非进入
            if data.__isClick == true then
                title:setSource(data.onSrc)
            else
                title:setSource(data.offSrc)
            end
        end

        function node:_onCellClick(data)
            if data.value.__isClick == true then
                title:setSource(data.value.onSrc)
            else
                title:setSource(data.value.offSrc)
            end
        end

        return node
    end
    local layer = THSTG.UI.newLayer()

    local title = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy * 2 - 40,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = "#diff_title.png",
    })
    layer:addChild(title)

    _uiTitleList = THSTG.UI.newTileList({
        x = display.cx,
        y = display.cy * 2 - 80,
        width = 450, 
        height = 535, 
        anchorPoint = THSTG.UI.POINT_CENTER_TOP,
        colCount = 1,
        itemColGap = 10,
        bounceEnabled = false,

        isOnChange = true,
        -- padding = {left= 0,right=0,top=0,bottom =5},
        direction = ccui.ListViewDirection.vertical,
        itemTemplate = createTemplate,
        onSelectedIndexChange = function (sender,node, index, value, lastIndex, lastValue)
            -- return _selectedChangedHandle(sender,node, index, value, lastIndex, lastValue)
        end,
    })
    layer:addChild(_uiTitleList)
    --------Control--------
    _selectedChangedHandle = function(sender,node, index, value, lastIndex, lastValue)

    end
    
    function layer.updateLayer()
        _uiTitleList:setDataProvider({
            {diffLevel = 1,onSrc = "#diff_1_on.png",offSrc = "#diff_1_off.png"},
            {diffLevel = 2,onSrc = "#diff_2_on.png",offSrc = "#diff_2_off.png"},
            {diffLevel = 3,onSrc = "#diff_3_on.png",offSrc = "#diff_3_off.png"},
            {diffLevel = 4,onSrc = "#diff_4_on.png",offSrc = "#diff_4_off.png"},
        })
        _uiTitleList:setSelected(1)
    end
    layer:onNodeEvent("enter", function ()
        layer.updateLayer()
	end)

	layer:onNodeEvent("exit", function ()
        
    end)


    return layer
end
return M