module(..., package.seeall)

local M = {}
function M.create(params)
    local node = THSTG.UI.newLayer()
  
    -- add background image
    local sprite = THSTG.UI.newImage({
        x= display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        source = "HelloWorld.png"
    })
    sprite:setOpacity(255 * 0.4)
    node:addChild(sprite)

    -------
    local tileList = THSTG.UI.newTileList({
        x = display.cx,
        y = display.cy,
        width = display.width,
        height = display.height,
        -- itemWidth = 68,
        -- itemHeight = 25,
        anchorPoint = THSTG.UI.POINT_CENTER,
        colCount = 9,
        itemRowGap = 6.4,
        bounceEnabled = false,

        isOnChange = true,
        direction = ccui.ListViewDirection.vertical,
        itemTemplate = function()
            local node = THSTG.UI.newNode({
                width = 64,
                height = 25,
            })
            local lable = THSTG.UI.newLinkLabel({
                x = node:getContentSize().width/2,
                y =node:getContentSize().height/2,
                anchorPoint = THSTG.UI.POINT_CENTER,
                style = {
                    normal = { label = { size=16, color=UI.COLOR_RED,  outline=1 }, },
                    pressed ={ label = { size=18, color=UI.COLOR_YELLLOW,  outline=2 }, },
                    disabled={ label = { size=25, color=UI.COLOR_GREEN, outline=6 }, },
                },
            })
            node:addChild(lable)

            function node:setState(data,pos)
                lable:setText(data.text)
                lable:onClick(data.onClick)
            end

            return node
        end,
    })
    node:addChild(tileList)

    node:onNodeEvent("enter", function ()
        tileList:setDataProvider({
            {
                text = "log测试" , 
                onClick = function(sender) 
                    print(0,"Test")
                end
            },
           
        })
	end)

	node:onNodeEvent("exit", function ()
        
    end)


    return node
end
return M