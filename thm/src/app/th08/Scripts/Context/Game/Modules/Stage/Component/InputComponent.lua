
local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local M = class("InputComponent",THSTG.ECS.Component)

function M:_onInit()
    self.keyMapper = THSTG.UTIL.newControlMapper()
    self.touchListener = nil
    self.keyboardListener = nil
end

function M:_onAdded(entity)

    self.keyboardListener = EventPublic.newKeyboardExListener({
        onPressed = function (keyCode, event)
            self.keyMapper:pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            self.keyMapper:releaseKey(keyCode)
        end,
    })

    self.touchListener = EventPublic.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            self.keyMapper:pressKey(ETouchType.OnceClick)
            return true
        end,
        onMoved = function(touches, event)
            if #touches > 1 then
                self.keyMapper:pressKey(ETouchType.MultiTouch)
            end
        end,
        onEnded = function(touches, event)
            self.keyMapper:releaseKey(ETouchType.OnceClick)
            self.keyMapper:releaseKey(ETouchType.Shake)
            self.keyMapper:releaseKey(ETouchType.DoubleClick)
            if #touches > 1 then
                self.keyMapper:releaseKey(ETouchType.MultiTouch)
            end
        end,
        onDoubleClick = function(touches, event)
            self.keyMapper:pressKey(ETouchType.DoubleClick)
        end,
        onShaked = function(touches, event)
            self.keyMapper:pressKey(ETouchType.Shake)
        end,
    })


    THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(self.keyboardListener, entity)
    THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(self.touchListener, entity)
end

function M:_onRemoved(entity)
    THSTG.CCDispatcher:removeEventListener(self.keyboardListener)
    THSTG.CCDispatcher:removeEventListener(self.touchListener)
end

return M