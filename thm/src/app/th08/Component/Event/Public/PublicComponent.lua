module("EventPublic", package.seeall)


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
    local listener = THSTG.EVENT.newKeyboardListener({
        onPressed = onPressed,
        onReleased = onReleased,
    })
    function listener:isKeyDown(keyCode)
        return _keyCache[keyCode]
    end

    ---
    local function onHandled()
        if tolua.isnull(listener) then
            THSTG.Scheduler.unschedule(_varScheduler)
            return 
        end
        if next(_keyCache) ~= nil then
            if type(params.onHandled) == "function" then
                params.onHandled(_keyCache)     --长处理
            end
        end
    end
    _varScheduler = THSTG.Scheduler.scheduleEachFrame(onHandled)

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

    _private.onDoubleClick = params.onDoubleClick or function(touches, event) end
    _private.onShaked = params.onShaked or function(touches, event) end
    _private.onLongClick = params.onLongClick or function(touches, event) end

    ---
    local _lastClickTime = 0
    local _lastMoveState = {pos = cc.p(0,0),time = 0,shift = cc.p(0,0)}

    ---
    local function onBegan(touches, event)
    
        local curClickTime = THSTG.TimeUtil.getHighPrecisionTime()
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
        local curTime = THSTG.TimeUtil.getHighPrecisionTime()
        
        local dTime = curTime - _lastMoveState.time
        if dTime > _private.shakeFreq then --取样频度
            local curShift = cc.pSub(curPos,_lastMoveState.pos)
            local angle = cc.pGetAngle(curShift,_lastMoveState.shift)
            local speed = cc.pGetLength(curShift) / dTime * 100
            
            if speed >= _private.shakeSpeed then
                if _lastMoveState.speedCheck then
                    local dTime = curTime - _lastMoveState.speedCheck.startTime 
                    if dTime <= _private.shakeInteral then
                        _private.onShaked()
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

        local curClickTime = THSTG.TimeUtil.getHighPrecisionTime()
        local isLongClick = curClickTime - _lastClickTime >= _private.longInteral
        if isLongClick then
            _private.onLongClick()
        end
        
        if type(params.onEnded) == "function" then
            params.onEnded(touches, event)
        end
    end

    local listener = THSTG.EVENT.newTouchAllAtOnceListener({
        onBegan = onBegan,
        onMoved = onMoved,
        onEnded = onEnded,
    })

    return listener
end