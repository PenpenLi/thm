module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
    local _uiTitleList = nil 




    --------View--------
    local node = THSTG.UI.newNode()

    local function createTemplate()
        local node = THSTG.UI.newWidget({
            width = 100,
            height = 25,
        })

        local title = THSTG.UI.newLabel({
            x = node:getContentSize().width/2,
            y = node:getContentSize().height/2,
            text = "测试",
            anchorPoint = THSTG.UI.POINT_CENTER,
            style = {
                color = THSTG.UI.COLOR_YELLOW,
                size = THSTG.UI.FONT_SIZE_NORMAL,
            }
        })
        node:addChild(title)
        
        --
        function node:setState(data, pos)
            if data.__isClick == true then
                
            else
                
            end
        end

        function node:_onCellClick(data)
            if data.value.__isClick == true then
               
            else
                
            end
        end
        return node
    end
    --

     --大背景
    --  local mainBg = THSTG.UI.newImage({
    --     x = display.cx,
    --     y = display.cy,
    --     anchorPoint = THSTG.UI.POINT_CENTER,
    --     src = ResManager.getUIRes(UIType.MAIN_SCENE, "") --TODO:

    -- })
    -- node:addChild(mainBg)

    _uiTitleList = THSTG.UI.newTileList({
        x = display.cx,
        y = display.cy,
        width = 582, 
        height = 348, 
        -- itemWidth = 558,
        -- itemHeight = 94,
        anchorPoint = THSTG.UI.POINT_CENTER_TOP,
        colCount = 1,
        -- itemRowGap = 10,
        itemColGap = 5,
        bounceable = false,
        -- padding = {left= 0,right=0,top=0,bottom =5},
        direction = ccui.ListViewDirection.vertical,
        itemTemplate = createTemplate,

    })
    node:addChild(_uiTitleList)
    debugUI(_uiTitleList)
    --------Control--------
    function node.updateLayer()
        _uiTitleList:setDataProvider({
            {},
            {},
            {},
            {},
        })
        
    end
    node:onNodeEvent("enter", function ()
        node.updateLayer()
	end)

	node:onNodeEvent("exit", function ()
        
    end)

    return node
end
return M