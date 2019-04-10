module(..., package.seeall)
local ETouchExType = DEFINITION.TouchExType
local M = class("InputSystem",ECS.System)

function M:_onInit()
    self.keyCache = {}
    self.touchState = ""
    self.touchPos = nil

    self._touchListener = nil
    self._keyboardListener = nil

    self._keyboardListener = EVENT.newKeyboardExListener({
        onPressed = function (keyCode, event)
            self.keyCache[keyCode] = true
        end,

        onReleased = function(keyCode, event)
            self.keyCache[keyCode] = false
        end,
    })

    self._touchListener = EVENT.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            self.keyCache[ETouchExType.OnceClick] = true
            self.touchState = "onBegan"
            self.touchPos = touches[1]:getLocation()
            return true
        end,
        onMoved = function(touches, event)
            if #touches > 1 then
                self.keyCache[ETouchExType.MultiTouch] = true
            end
            self.touchState = "onMoved"
            self.touchPos = touches[1]:getLocation()
        end,
        onEnded = function(touches, event)
            self.keyCache[ETouchExType.OnceClick] = false
            self.keyCache[ETouchExType.Shake] = false
            self.keyCache[ETouchExType.DoubleClick] = false
            if #touches > 1 then
                self.keyCache[ETouchExType.MultiTouch] = false
            end
            self.touchState = "onEnded"
            self.touchPos = touches[1]:getLocation()
        end,
        onDoubleClick = function(touches, event)
            self.keyCache[ETouchExType.DoubleClick] = true
        end,
        onShaked = function(touches, event)
            self.keyCache[ETouchExType.Shake] = true
        end,
    })
    
    Dispatcher.addEventListener(TYPES.EVENT.SCENEMGR_CHANGED, self._addListenerHandle,self)
end

function M:_addListenerHandle(e,params)
    local node = params
    CCDispatcher:addEventListenerWithSceneGraphPriority(self._keyboardListener, node)
    CCDispatcher:addEventListenerWithSceneGraphPriority(self._touchListener, node)
end

function M:isKeyDown(keyCode)
    return keyCache[keyCode] or false
end
function M:getTouchState()
    return self.touchState
end

function M:getTouchPosition()
    return self.touchPos
end

function M:_onLateUpdate(delay)
    if self.touchState ~= "onMoved" then
        self.touchState = ""
        self.touchPos = nil
    end
end
return M