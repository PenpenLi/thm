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
    params.onMoved = params.onMoved or function(touch, event) end
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
    params.onMoved = params.onMoved or function(touches, event) end
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

----


--@params [function] onHandled      --有按键是触发
    function newKeyboardExListener(params)
        local _keyCache = {}
        local _varScheduler = nil
        ---
        local function onPressed(keyCode, event)
            _keyCache[keyCode] = true
            if type(params.onPressed) == "function" then
                params.onPressed(keyCode, event)
            end
        end
        local function onReleased(keyCode, event)
            _keyCache[keyCode] = nil
            if type(params.onReleased) == "function" then
                params.onReleased(keyCode, event)
            end
        end
    
       
        --
        local listener = EVENT.newKeyboardListener({
            onPressed = onPressed,
            onReleased = onReleased,
        })
        function listener:isKeyDown(keyCode)
            return _keyCache[keyCode]
        end
    
        ---
        local function onHandled()
            if tolua.isnull(listener) then
                Scheduler.unschedule(_varScheduler)
                return 
            end
            if next(_keyCache) ~= nil then
                params.onHandled(_keyCache)
            end
        end
        if type(params.onHandled) == "function" then
            _varScheduler = Scheduler.scheduleEachFrame(onHandled)
        end
    
        return listener
    end
    
    
    --@params [function] onDoubleClick      --双击触发
    --@params [function] onShaked           --擦拭动作触发
    --@params [function] onLongClick      --长按触发
    function newTouchAllAtOnceExListener(params)
    
        local _private = {}
        _private.doubleInteral = 400
        _private.longInteral = 1000
        _private.shakeFreq = 50
        _private.shakeInteral = 100
        _private.shakeSpeed = 180
        _private.shakeSafeDistance = 170
    
        _private.onDoubleClick = params.onDoubleClick or function(touches, event) end
        _private.onShaked = params.onShaked or function(touches, event) end
        _private.onLongClick = params.onLongClick or function(touches, event) end
    
        ---
        local _startMovePos = nil
        local _lastClickTime = 0
        local _lastMoveState = {pos = cc.p(0,0),time = 0,shift = cc.p(0,0)}
    
        ---
        local function onBegan(touches, event)
            _startMovePos = touches[1]:getLocation()
            local curClickTime = TimeUtil.getHighPrecisionTime()
            local isDouble = curClickTime - _lastClickTime <= _private.doubleInteral
            if isDouble then
                _private.onDoubleClick(touches, event)
            end
            _lastClickTime = curClickTime
    
            if type(params.onBegan) == "function" then
                params.onBegan(touches, event)
            end
    
            return true
        end
        local function onMoved(touches, event)
            local curPos = touches[1]:getLocation()
            local curTime = TimeUtil.getHighPrecisionTime()
            
            local dTime = curTime - _lastMoveState.time
            if dTime > _private.shakeFreq then --取样频度
                local curShift = cc.pSub(curPos,_lastMoveState.pos)
                local angle = cc.pGetAngle(curShift,_lastMoveState.shift)
                local speed = cc.pGetLength(curShift) / dTime * 100
                
                if speed >= _private.shakeSpeed then
                    if _lastMoveState.speedCheck then
                        local dTime = curTime - _lastMoveState.speedCheck.startTime 
                        if dTime <= _private.shakeInteral then
                            --还得判断一下起点和终点的距离是否超过范围距离
                            local distance = cc.pGetLength(cc.pSub(curPos,_startMovePos))
                            if distance <= _private.shakeSafeDistance then
                                _private.onShaked()
                            end
                            _lastMoveState.speedCheck = nil
                        end
                    else
                        _lastMoveState.speedCheck = {}
                        _lastMoveState.speedCheck.startTime = curTime
                    end
                else
                    _lastMoveState.speedCheck = nil
                end
    
                --
                _lastMoveState.pos = curPos
                _lastMoveState.time = curTime
                _lastMoveState.shift = curShift
            end
    
    
            if type(params.onMoved) == "function" then
                params.onMoved(touches, event)
            end
        end
        local function onEnded(touches, event)
    
            local curClickTime = TimeUtil.getHighPrecisionTime()
            local isLongClick = curClickTime - _lastClickTime >= _private.longInteral
            if isLongClick then
                _private.onLongClick()
            end
            
            if type(params.onEnded) == "function" then
                params.onEnded(touches, event)
            end
        end
    
        local listener = EVENT.newTouchAllAtOnceListener({
            onBegan = onBegan,
            onMoved = onMoved,
            onEnded = onEnded,
        })
    
        return listener
    end