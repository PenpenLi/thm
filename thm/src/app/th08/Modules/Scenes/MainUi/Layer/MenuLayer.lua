module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
    local _uiTitleList = nil 



    local _selectedChangedHandle = nil
    --------View--------
    local node = THSTG.UI.newNode()

    local _data = nil
    local function createTemplate()
        local node = THSTG.UI.newWidget({
            width = 200,
            height = 25,
        })

        local title = THSTG.UI.newBMFontLabel({
            x = node:getContentSize().width/2,
            y = node:getContentSize().height/2,
            anchorPoint = THSTG.UI.POINT_CENTER,
            style = {
                font = ResManager.getResSub(ResType.FONT, FontType.FNT, "menu_font_black"),
            }
        })
        node:addChild(title)
        
        --
        function node:setState(data, pos)
            _data = data

            title:setText(data.title)
            --TODO:偏移动作

        end
        function node:getData()
            return _data
        end
        function node:_onCellClick(data,isClick)
            if isClick == true then
                title:setFntFile(ResManager.getResSub(ResType.FONT, FontType.FNT, "menu_font_white"))
            else
                title:setFntFile(ResManager.getResSub(ResType.FONT, FontType.FNT, "menu_font_black"))
            end
        end

        return node
    end
    --

    --  大背景
    --  local mainBg = THSTG.UI.newImage({
    --     x = display.cx,
    --     y = display.cy,
    --     anchorPoint = THSTG.UI.POINT_CENTER,
    --     src = ResManager.getUIRes(UIType.MAIN_SCENE, "") --TODO:

    -- })
    -- node:addChild(mainBg)

    _uiTitleList = THSTG.UI.newTileList({
        x = 138,
        y = 286,
        width = 250, 
        height = 280, 
        anchorPoint = THSTG.UI.POINT_CENTER_TOP,
        colCount = 1,
        itemColGap = 5,
        bounceEnabled = false,
        -- padding = {left= 0,right=0,top=0,bottom =5},
        direction = ccui.ListViewDirection.vertical,
        itemTemplate = createTemplate,
        onSelectedIndexChange = function (sender,node, index, value, lastIndex, lastValue)
            return _selectedChangedHandle(sender,node, index, value, lastIndex, lastValue)
        end,
    })
    node:addChild(_uiTitleList)
    --------Control--------
    _selectedChangedHandle = function (sender,node, index, value, lastIndex, lastValue)
        local data = node:getData()
        
    end

    function node.updateLayer()
        local infos = MainSceneConfig.getMainMenuInfo()
        _uiTitleList:setDataProvider(infos)
        _uiTitleList:setSelected(1)
    end
    node:onNodeEvent("enter", function ()
        node.updateLayer()
	end)

	node:onNodeEvent("exit", function ()
        
    end)

    return node
end
return M