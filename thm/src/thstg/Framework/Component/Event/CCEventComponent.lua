module("EVENT", package.seeall)

function getEventDispatcher()
    return cc.Director:getInstance():getEventDispatcher()
end

function newKeyboardListener(params)
    params = params or {}
    params.onPressed =  params.onPressed or function(keyCode, event) end
    params.onReleased =  params.onReleased or function(keyCode, event) end

    local listener = cc.EventListenerKeyboard:create()

    listener:registerScriptHandler(params.onPressed,cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(params.onReleased,cc.Handler.EVENT_KEYBOARD_RELEASED)

    return listener
end

function newTouchOneByOneListener(params)
    params = params or {}
    params.onBegan = params.onBegan or function(touch, event) end
    params.onMoved = params.onMove or function(touch, event) end
    params.onEnded = params.onEnded or function(touch, event) end

    local listener = cc.EventListenerTouchOneByOne:create()
 
    listener:registerScriptHandler(params.onBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(params.onMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(params.onEnded, cc.Handler.EVENT_TOUCH_ENDED)

    return listener
end

function newTouchAllAtOnceListener(params)
    params = params or {}
    params.onBegan = params.onBegan or function(touches, event) end
    params.onMoved = params.onMove or function(touches, event) end
    params.onEnded = params.onEnded or function(touches, event) end

    local listener = cc.EventListenerTouchAllAtOnce:create()
 
    listener:registerScriptHandler(params.onBegan, cc.Handler.EVENT_TOUCHES_BEGAN)
    listener:registerScriptHandler(params.onMoved, cc.Handler.EVENT_TOUCHES_MOVED)
    listener:registerScriptHandler(params.onEnded, cc.Handler.EVENT_TOUCHES_ENDED)

    return listener
end


function newMouseListener(params)
    params = params or {}
    params.onUp = params.onUp or function(event) end
    params.onDown = params.onDown or function(event) end
    params.onMove = params.onMove or function(event) end
    params.onScroll = params.onScroll or function(event) end

    local listener = cc.EventListenerMouse:create()
    listener:registerScriptHandler(params.onUp, cc.Handler.EVENT_MOUSE_UP)
    listener:registerScriptHandler(params.onDown, cc.Handler.EVENT_MOUSE_DOWN)
    listener:registerScriptHandler(params.onMove, cc.Handler.EVENT_MOUSE_MOVE)
    listener:registerScriptHandler(params.onScroll, cc.Handler.EVENT_MOUSE_SCROLL)

    return listener
end

function newAccelerationListener(params)
    params = params or {}
    params.onAcceleration = params.onAcceleration or function(event,acceleration,timestamp) end
    local function onAccelerationEvent(event, x, y, z, timestamp)
        local args = {x=x,y=y,z=z}
        params.onAcceleration(event,args,timestamp)
    end
    -- 直接传入 响应函数 作为参数
    local listener = cc.EventListenerAcceleration:create(onAccelerationEvent)
    
    return listener
end
