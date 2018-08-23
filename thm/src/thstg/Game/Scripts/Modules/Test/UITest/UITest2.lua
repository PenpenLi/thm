module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

    --ScrollView
    local sv2 = THSTG.UI.newScrollView({
        x = 100, y = 310,
        width = 200, height = 200,
        innerWidth = 300, innerHeight = 300,
        bounceEnabled = false,
        anchorPoint = THSTG.UI.POINT_CENTER,
        direction = ccui.ScrollViewDir.horizontal,
        style = {
            bgColor = THSTG.UI.COLOR_WHITE,
        }
    })
    layer:addChild(sv2)

    local btnSv1 = THSTG.UI.newButton({
        x = 50,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        isTouchAction = false,
        style = {
            normal ={
                skin = {src = "Assets/UI/Button/power1_close.png"}
            },
            selected = {
                skin = {src = "Assets/UI/Button/power1_open.png"}
            },
        }
    })
    sv2:addChild(btnSv1)



    --ScrollView
    local sv2 = THSTG.UI.newScrollView({
        x = 500, y = 310,
        width = 200, height = 200,
        innerWidth = 300, innerHeight = 300,
        bounceEnabled = false,
        anchorPoint = THSTG.UI.POINT_CENTER,
        direction = ccui.ScrollViewDir.vertical,
        style = {
            bgColor = THSTG.UI.COLOR_WHITE,
        }
    })
    layer:addChild(sv2)

    local btnSv1 = THSTG.UI.newButton({
        x = 50,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        isTouchAction = false,
        style = {
            normal ={
                skin = {src = "Assets/UI/Button/power1_close.png"}
            },
            selected = {
                skin = {src = "Assets/UI/Button/power1_open.png"}
            },
        }
    })
    sv2:addChild(btnSv1)

    local pageView = THSTG.UI.newPageView({
        x = display.cx,
		y = 130,
		width = 400,
		height = 200,
		anchorPoint = THSTG.UI.POINT_CENTER,
		numPages = 3,
		defaultPage = 1,
		scrollThreshold = 50,
		style = {
			bgColor = THSTG.UI.COLOR_GRAY_B,
			pagePoint = {
                selectedSkinSrc = "Assets/UI/PageView/page_sel1.png",
		        normalSkinSrc =  "Assets/UI/PageView/page_disa1.png",
				offsetY = -20,
			}
		},
		onChange = function(sender, curPage, prevPage)
		print(15, "~~~~~~~~~", sender, curPage, prevPage)
		end

    })
    layer:addChild(pageView)
    
    local scrooView = THSTG.UI.newScrollView({
		x = 0,
		y = 0,
		anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
		width = 200,
		height = 200,
		innerWidth = 300, innerHeight = 300,
		style = {
			bgColor = THSTG.UI.COLOR_BLACK,
		},
	})
	pageView:addChildToPage(2, scrooView)

    local btn = THSTG.UI.newButton({
        x = 50,
        y = 200,
        anchorPoint = THSTG.UI.POINT_CENTER,
        style = {
            normal ={
                skin = {src = "Assets/UI/Button/power1_close.png"}
            },
            selected = {
                skin = {src = "Assets/UI/Button/power1_open.png"}
            },
        }
    })
    scrooView:addChild(btn)


    --
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
    local pageTileView = THSTG.UI.newPageTileView({
        x = 100,
        y = 270,
        width = 225,
        height = 160,
        isCancelState = true,
        showPagePoint = true,
        -- itemRowGap = 0,
        -- itemColGap = 0,
        colCount = 3,
        rowCount = 2,
        itemHeight = 100,
        itemWidth = 100,
        itemTemplate = createTemplate,
        style = {
			bgColor = THSTG.UI.COLOR_GRAY_B,
			pagePoint = {
                selectedSkinSrc = "Assets/UI/PageView/page_sel1.png",
		        normalSkinSrc =  "Assets/UI/PageView/page_disa1.png",
				offsetY = -20,
			}
		},
    })
    layer:addChild(pageTileView)

    pageTileView:setDataProvider({
        {},
        {},
        {},
        {},
        {},
        {},
        {},
        {},
    })
    pageTileView:scrollToPage(1)
    
    return layer
end
return M