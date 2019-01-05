

local ETouchType = Definition.Public.ETouchType
local M = class("InputComponent",THSTG.ECS.Component)

function M:_onInit()
    self.keyMapper = THSTG.UTIL.newControlMapper()
    self.touchState = ""
    self.touchPos = nil

    self._touchListener = nil
    self._keyboardListener = nil
end
---

function M:isKeyDown(type)
    return self.keyMapper:isKeyDown(type)
end

function M:resetKey(type)
    return self.keyMapper:resetKey(type)
end

function M:getTouchState()
    return self.touchState
end

function M:getTouchPos()
    return self.touchPos
end
--
function M:_setTouchs(touchs)
    if touchs then 
        touchs:retain()
        self.touchs = touchs
    else
        if self.touchs then
            self.touchs:release()
            self.touchs = nil
        end
    end
end
---
function M:_onAdded(entity)

    self._keyboardListener = THSTG.EVENT.newKeyboardExListener({
        onPressed = function (keyCode, event)
            self.keyMapper:pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            self.keyMapper:releaseKey(keyCode)
        end,
    })

    self._touchListener = THSTG.EVENT.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            self.keyMapper:pressKey(ETouchType.OnceClick)
            self.touchState = "onBegan"
            self.touchPos = touches[1]:getLocation()
            return true
        end,
        onMoved = function(touches, event)
            if #touches > 1 then
                self.keyMapper:pressKey(ETouchType.MultiTouch)
            end
            self.touchState = "onMoved"
            self.touchPos = touches[1]:getLocation()
        end,
        onEnded = function(touches, event)
            self.keyMapper:releaseKey(ETouchType.OnceClick)
            self.keyMapper:releaseKey(ETouchType.Shake)
            self.keyMapper:releaseKey(ETouchType.DoubleClick)
            if #touches > 1 then
                self.keyMapper:releaseKey(ETouchType.MultiTouch)
            end
            self.touchState = "onEnded"
            self.touchPos = touches[1]:getLocation()
        end,
        onDoubleClick = function(touches, event)
            self.keyMapper:pressKey(ETouchType.DoubleClick)
        end,
        onShaked = function(touches, event)
            self.keyMapper:pressKey(ETouchType.Shake)
        end,
    })


    THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(self._keyboardListener, entity)
    THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(self._touchListener, entity)
end

function M:_onRemoved(entity)
    THSTG.CCDispatcher:removeEventListener(self._keyboardListener)
    THSTG.CCDispatcher:removeEventListener(self._touchListener)
end

function M:_onLateUpdate()
    if self.touchState ~= "onMoved" then
        self.touchState = ""
        self.touchPos = nil
    end
end


return M