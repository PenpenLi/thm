module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()
    -- add background image
    THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = "Assets/HelloWorld.png"
    })
    :addTo(layer)

    -- add HelloWorld label
    THSTG.UI.newLabel({
        x = display.cx,
        y = display.cy+200,
        text = "Hello World",
        anchorPoint = THSTG.UI.POINT_CENTER,
        style = {
            font = "Arial",
            size = 40,
        }
    })
    :addTo(layer)

    local titleLabel = THSTG.UI.newLabel({
        text = "Label 的 一XX个测试",
        x = 110,
        y = 30, 
   
        style = {
            --font = "Arial",
        }
    })
    :addTo(layer)

    local titleLabel = THSTG.UI.newRichText({
        text = "RichText,<font style={color=ColorConfig.getColorType('qua_green')}>帽子绿</font>,<font style={color=ColorConfig.getColorType('qua_red')}>姨妈红</font>",
        x = 310,
        y = 30, 
   
        style = {
            --font = "Arial",
        }
    })
    :addTo(layer)

    local sprite = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        src = "res/th08/title01.png",
        frame = {x= 0,y = 0,width =100,height=100},
    })
    :addTo(layer)

    local btn = THSTG.UI.newButton({
		x = 50,
		y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        isTouchAction = false,
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
    :addTo(layer)

    --一张图片
    local iamge1 = THSTG.UI.newImage({
        x = display.cx-100,
        y = display.cy-100,
        style = {
            src = "res/th08/eff03b.png",
            scale9Rect = {left= 0,top = 0,right =100,bottom=100},
        }
    })
    :addTo(layer)

    --
    local label = THSTG.UI.newAtlasLabel({
        text = "12345",
        x = display.cx+80,
        y = display.cy+100,
        style = {
            font = {
                src = "Assets/Font/pvp_shu2.png", 
                itemWidth = 34.6,
                itemHeight = 53,
            }
        }
    })  
    layer:addChild(label)

    --
    local label = THSTG.UI.newBMFontLabel({
        x = display.cx+80,
        y = display.cy+80,
        text = "王圣田",
        anchorPoint = THSTG.UI.POINT_CENTER_TOP,
        style = {
            font = ResManager.getResSub(ResType.FONT, FontType.FNT, "activity_yeqian"),
            additionalKerning = -4,
            -- lineHeight = 28
        }
    })

    layer:addChild(label)
    --
    --一个按钮
    local btn2 = ccui.Button:create("Assets/UI/Button/power1_close.png", "Assets/UI/Button/power1_open.png")
    btn2:setPosition(50,display.cy-100)
    btn2:setAnchorPoint(cc.p(0.5,0.5))
    btn2:ignoreContentAdaptWithSize(false)
    btn2:addTouchEventListener(function(sender, eventType)
        local event = {x = 0, y = 0}
        event.target = sender
        local beganPos = sender:getTouchBeganPosition()
        event.x,event.y = beganPos.x,beganPos.y


        if eventType == ccui.TouchEventType.began then
            --获取起始坐标

			event.name = "began"
        elseif eventType == ccui.TouchEventType.moved then
            --获取移动坐标
            local curPos = sender:getTouchMovePosition()
            event.x,event.y = curPos.x,curPos.y
			event.name = "moved"
		elseif eventType == ccui.TouchEventType.ended then	
			event.name = "ended"
		elseif eventType == ccui.TouchEventType.canceled then
			event.name = "cancelled"
        end
        --OnTouch
        print(event.name ,event.x,event.y )
    end
    )
	btn2:setEnabled(true)
    layer:addChild(btn2)

    --

    local togglebutton = THSTG.UI.newToggleButton({
		x = 500, y = 120,
		onClick = function (sender, isToggle, customNode)
			print("state: "..tostring(isToggle))
		end,
		width = 100, height = 100,
		toggleNode = THSTG.UI.newLabel({
			text = "Toggle",
			x = 50, y = 50,
			anchorPoint = THSTG.UI.POINT_CENTER,
		}),
		distoggleNode = THSTG.UI.newLabel({
			text = "disToggle",
			x = 50, y = 50,
			anchorPoint = THSTG.UI.POINT_CENTER,
        }),
        style = {
			toggle = {
				normal = {
					skin = {
						src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open")
					},
				}
			},
			distoggle = {
				normal = {
					skin = {
						src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
					},
				}
			},
		},
	})
    layer:addChild(togglebutton)
    


    local tintoLabel = THSTG.UI.newTintoLabel({
        x = 100,y = 100,
        text = "这是一个颜色从上到下渐变的\"文本\"",
        topColor = "#fbf047",
        bottomColor = "#42cdeb",
        style = {
            size = 30
        }
    })
    layer:addChild(tintoLabel)



    return layer
end
return M