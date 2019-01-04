
local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local M = class("InputComponent",THSTG.ECS.Component)

function M:_onInit()
    self.keyMapper = THSTG.UTIL.newControlMapper()
    self.keyCache = {}
    self.touchPos = nil
    self.touchState = nil
    
    self._touchListener = nil
    self._keyboardListener = nil
end

---
function M:_onAdded(entity)

    self._keyboardListener = THSTG.EVENT.newKeyboardExListener({
        onPressed = function (keyCode, event)
            self.keyMapper:pressKey(keyCode)
            self.keyCache[keyCode] = true
        end,

        onReleased = function(keyCode, event)
            self.keyMapper:releaseKey(keyCode)
            self.keyCache[keyCode] = false
        end,
    })

    self._touchListener = THSTG.EVENT.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            self.keyMapper:pressKey(ETouchType.OnceClick)
            self.touchPos = touches[1]:getLocation()
            self.touchState = "onBegan"
            return true
        end,
        onMoved = function(touches, event)
            if #touches > 1 then
                self.keyMapper:pressKey(ETouchType.MultiTouch)
            end
            self.touchPos = touches[1]:getLocation()
            self.touchState = "onMoved"
        end,
        onEnded = function(touches, event)
            self.keyMapper:releaseKey(ETouchType.OnceClick)
            self.keyMapper:releaseKey(ETouchType.Shake)
            self.keyMapper:releaseKey(ETouchType.DoubleClick)
            if #touches > 1 then
                self.keyMapper:releaseKey(ETouchType.MultiTouch)
            end
            self.touchPos = nil
            self.touchState = "onEnded"
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
        self.touchState = nil
    end
end


return M