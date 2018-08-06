module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

    -- add background image
    THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = "HelloWorld.png"
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
                src = "res/pvp_shu2.png", 
                itemWidth = 34.6,
                itemHeight = 53,
            }
        }
    })  
    layer:addChild(label)
    --
    --一个按钮
    local btn2 = ccui.Button:create("res/close.png", "res/open.png")
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
    return layer
end
return M