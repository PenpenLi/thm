module(..., package.seeall)

local M = class("TestModule", View)

function M:onCreate()
    -- add background image
    THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = "HelloWorld.png"
    })
    :addTo(self)

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
    :addTo(self)

    local titleLabel = UI.newLabel({
        text = "Label 的 一XX个测试",
        x = 110,
        y = 30, 
   
        style = {
            --font = "Arial",
        }
    })
    :addTo(self)

    local sprite = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy,
        src = "res/th08/title01.png",
        frame = {x= 0,y = 0,width =100,height=100},
    })
    :addTo(self)

    local btn = UI.newButton({
		x = 50,
		y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        isTouchAction = false,
        style = {
            normal ={
                skin = {src = "res/close.png"}
            },
            selected = {
				skin = {src = "res/open.png"}
			},
        }
	})
    :addTo(self)
    
    --一张图片
    local iamge1 = UI.newImage({
        x = display.cx-100,
        y = display.cy-100,
        style = {
            src = "res/th08/eff03b.png",
            scale9Rect = {left= 0,top = 0,right =100,bottom=100},
        }
    })
    :addTo(self)

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
    self:addChild(btn2)

    --一个ScrollView
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
	self:addChild(sv2)
    
    --一个Window

    --一个LayerStack

    --一个TabBar


    --事件监听
    -- -- 注册键盘事件
    local dispatcher = THSTG.EVENT.getEventDispatcher()
    local listener = THSTG.EVENT.newKeyboardListener({
        onPressed = function(keyCode, event)
            if keyCode == cc.KeyCode.KEY_W then
                print("Pressed W !") 
            elseif keyCode == cc.KeyCode.KEY_S then
                print("Pressed S !")
            elseif keyCode == cc.KeyCode.KEY_A then
                print("Pressed A !")
            elseif keyCode == cc.KeyCode.KEY_D then
                print("Pressed D !")
            elseif keyCode == cc.KeyCode.KEY_H then
                print("Pressed H !")
            elseif keyCode == cc.KeyCode.KEY_J then
                print("Pressed J !")
            elseif keyCode == cc.KeyCode.KEY_K then
                print("Pressed K !")
            elseif keyCode == cc.KeyCode.KEY_LEFT_SHIFT then
                print("Pressed Left Shift !")
            end
        end,
    })


end

return M