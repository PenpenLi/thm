module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

    local function createTemplate()
        local widget = THSTG.UI.newWidget({
            width = 100,
            height = 100,
        })
        debugUI(widget)
        
        local btn = THSTG.UI.newButton({
            x = widget:getContentSize().width/2,
            y = widget:getContentSize().height/2+20,
            anchorPoint = THSTG.UI.POINT_CENTER,
            style = {
                normal ={
                    skin = {
                        src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open")
                    }
                },
                selected = {
                    skin = {
                        src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
                    }
                },
            }
        })
        widget:addChild(btn)
        
        local label = THSTG.UI.newLabel({
            x = widget:getContentSize().width/2,
            y = 30,
            text = "",
            anchorPoint = THSTG.UI.POINT_CENTER,
            style = {
                color = ColorConfig.getColorType("text_normal2"),
                size = THSTG.UI.FONT_SIZE_NORMAL,
            }
        })
        widget:addChild(label)

        function widget:setState(data,pos)
            label:setText(pos)
            btn:onClick(function ()
                print(15,"click:",pos)
            end)
        end

        return widget
    end

    local list = THSTG.UI.newTileList({
		x = display.cx,
		y = display.cy,
		width = 286,
		height = 430,
		itemWidth = 100,
		itemHeight = 100,
		itemColGap = 4,
        colCount = 2,
        rowCount = 2,
		direction = ccui.ListViewDirection.vertical,
		anchorPoint = THSTG.UI.POINT_LEFT_TOP,
		itemTemplate = createTemplate,
		onSelectedIndexChange = function(sender, curNode, curIndex, lastNode, lastIndex)
			print(15,"curIndex:",curIndex)
		end
	})
	layer:addChild(list)

    list:setDataProvider({
        {},
        {},
        {},
        {},
    })

    --
  

    return layer
end
return M
