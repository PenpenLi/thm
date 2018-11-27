module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

    --ScrollView
    local sv1 = THSTG.UI.newScrollView({
        x = display.cx, y = display.cy,
        width = 200, height = 200,
        innerWidth = 400, innerHeight = 400,
        bounceEnabled = false,
        anchorPoint = THSTG.UI.POINT_CENTER,
        style = {
            bgColor = THSTG.UI.COLOR_WHITE,
        }
    })
    layer:addChild(sv1)

	local sp = THSTG.UI.newSprite({
        x = sv1:getContentSize().width/2,
        y = sv1:getContentSize().height/2,
        src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open"),
    })
	sv1:addChild(sp)

	local lb = THSTG.UI.newLabel({
		text = "100%",
		x = sp:getPositionX(), y = sp:getPositionY(),
		anchorPoint = THSTG.UI.POINT_CENTER
	})
	sv1:addChild(lb)

	local slider1 = THSTG.UI.newSlider({
        x = sv1:getContentSize().width/2,
        y = sv1:getContentSize().height/2-100,
		height = 20,
        percent = 50,
        style = {
			bgSkin = {
                src = "Assets/UI/Slider/slider_bg1.png",
	            scale9Rect = {left = 10, right = 10, top = 5, bottom = 5}
            },
			progressSkin = {
                src = "Assets/UI/Slider/slider_sel1.png",
	            scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
            },
			thumbSkin = {
                src = "Assets/UI/Slider/slider_btn1.png",
            },
        },
		onChange = function (sender, percent)
            sp:setOpacity(255 * percent / 100)
            lb:setText(tostring(percent).."%")
        end,
	})
    sv1:addChild(slider1)
    
    local slider2 = THSTG.UI.newSlider({
        x = sv1:getContentSize().width/2+100,
        y = sv1:getContentSize().height/2,
		height = 20,
        percent = 50,
        style = {
			bgSkin = {
                src = "Assets/UI/Slider/slider_bg1.png",
	            scale9Rect = {left = 10, right = 10, top = 5, bottom = 5}
            },
			progressSkin = {
                src = "Assets/UI/Slider/slider_sel1.png",
	            scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
            },
			thumbSkin = {
                src = "Assets/UI/Slider/slider_btn1.png",
            },
        },
		onChange = function (sender, percent)
            sp:setOpacity(255 * percent / 100)
            lb:setText(tostring(percent).."%")
        end,
    })
    slider2:setRotation(90)
	sv1:addChild(slider2)

    --
	local tx = THSTG.UI.newLabel({
		text = "0",
		x = display.cx, y = 250,
		anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
		style = {size = 35, color = THSTG.UI.COLOR_GRAY_E}
	})
    layer:addChild(tx)

    local function onBarChange(node, newvalue, oldvalue)
        tx:setText(math.floor(node:getCurPercent()))
    end

    local scrolBarV = THSTG.UI.newScrollBar({
        x = display.cx+200, y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        direction = ccui.ScrollViewDir.vertical,
        style = {
            clickStyle = {
                normal = {
                    skin = {
                        src = "Assets/UI/ScrollBar/bg_default.png",
                        scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
                    }
                }
            },
			scrollBgStyle = {
                src = "Assets/UI/ScrollBar/bg_default.png",
	            scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
            },
			scrollFrontStyle = {
                src = "Assets/UI/ScrollBar/progress_default.png",
                scale9Rect = {left = 10, right = 10, top = 10, bottom = 10} 
            },
        },
        onChange = function(node, newvalue, oldvalue)
            onBarChange(node, newvalue, oldvalue)

            sv1:scrollToPercentVertical( newvalue,0.2,false)
        end,
	})
	layer:addChild(scrolBarV)


	local scrolBarH = THSTG.UI.newScrollBar({
        x = display.cx, y = display.cy -200,
        anchorPoint = THSTG.UI.POINT_CENTER,
        direction = ccui.ScrollViewDir.horizontal,
        style = {
            clickStyle = {
                normal = {
                    skin = {
                        src = "Assets/UI/ScrollBar/bg_default.png",
                        scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
                    }
                }
            },
			scrollBgStyle = {
                src = "Assets/UI/ScrollBar/slider_bg1.png",
	            scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
            },
			scrollFrontStyle = {
                src = "Assets/UI/ScrollBar/slider_sel1.png",
                scale9Rect = {left = 10, right = 10, top = 10, bottom = 10} 
            },
        },
	})
	layer:addChild(scrolBarH)

    scrolBarH:registerScrollBarChangeHandler(function (node, newvalue, oldvalue)
        onBarChange(node, newvalue, oldvalue)
        
        sv1:scrollToPercentHorizontal( newvalue,0.2,false)
	end)



    return layer
end
return M