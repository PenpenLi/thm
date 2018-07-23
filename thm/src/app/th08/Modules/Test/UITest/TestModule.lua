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


    local btn = THSTG.UI.newButton({
		x = 50,
		y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
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
    
    --一个按钮
    local btn2 = ccui.Button:create("res/close.png", "res/open.png")
    btn2:setPosition(display.cx,display.cy)
    btn2:setAnchorPoint(cc.p(0.5,0.5))
    btn2:ignoreContentAdaptWithSize(false)
    btn2:addTouchEventListener(function(sender, eventType)
        local event = {x = 0, y = 0}
        event.target = sender
        
        if eventType == ccui.TouchEventType.began then
            --获取起始坐标
            local beganPos = sender:getTouchBeganPosition()
			event.name = "began"
        elseif eventType == ccui.TouchEventType.moved then
            --获取移动坐标
            local curPos = sender:getTouchMovePosition()
			event.name = "moved"
		elseif eventType == ccui.TouchEventType.ended then	
			event.name = "ended"
		elseif eventType == ccui.TouchEventType.canceled then
			event.name = "cancelled"
        end
        --OnTouch
        dump(15,event)
    end
    )
	btn2:setEnabled(true)
    self:addChild(btn2)

    --一个Window

    --一个LayerStack

    --一个TabBar
end

return M