module(..., package.seeall)
local EGameKeyType = Definitions.Public.EGameKeyType
local ETouchType = Definitions.Public.ETouchType
local M = {}
local Player = class("Player",cc.Node)
function Player:ctor()
    self.__rigidBodyRect = cc.rect(0,0,40,40)
    self.__mainSprite = THSTG.UI.newSprite()
    self.__cmpControlMapper = THSTG.COMMON.newControlMapper()

    self._varMoveStep = {x = 0,y = 0}
    self._varDestPos = false
    --
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_W,EGameKeyType.MoveUp)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_UP_ARROW,EGameKeyType.MoveUp)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_S,EGameKeyType.MoveDown)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_DOWN_ARROW,EGameKeyType.MoveDown)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_A,EGameKeyType.MoveLeft)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_LEFT_ARROW,EGameKeyType.MoveLeft)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_D,EGameKeyType.MoveRight)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_RIGHT_ARROW,EGameKeyType.MoveRight)

    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_Z,EGameKeyType.Attack)
    self.__cmpControlMapper:registerKey(ETouchType.OneClick,EGameKeyType.Attack)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_H,EGameKeyType.Attack)

    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_X,EGameKeyType.Wipe)
    self.__cmpControlMapper:registerKey(ETouchType.Shake,EGameKeyType.Wipe)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_J,EGameKeyType.Wipe)

    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_C,EGameKeyType.Skill)
    self.__cmpControlMapper:registerKey(ETouchType.DoubleClick,EGameKeyType.Skill)
    self.__cmpControlMapper:registerKey(cc.KeyCode.KEY_K,EGameKeyType.Skill)
    ----
    self.__keyboardListener = EventPublic.newKeyboardExListener({
        onPressed = function (keyCode, event)
            self.__cmpControlMapper:pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            self.__cmpControlMapper:releaseKey(keyCode)
            self._varMoveStep = {x = 0,y = 0}
        end,

    })

    self.__touchAllListener = EventPublic.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            --有触屏就有攻击
            local curPos = touches[1]:getLocation()
            self._varDestPos = {x = curPos.x, y = curPos.y}
            self.__cmpControlMapper:pressKey(ETouchType.OneClick)
            return true
        end,
        onMoved = function(touches, event)
            local curPos = touches[1]:getLocation()
            self._varDestPos = {x = curPos.x, y = curPos.y}
        end,
        onEnded = function(touches, event)
            self._varDestPos = false
            self.__cmpControlMapper:releaseKey(ETouchType.OneClick)
            self.__cmpControlMapper:releaseKey(ETouchType.Shake)
            self.__cmpControlMapper:releaseKey(ETouchType.DoubleClick)
        end,
        --
        onDoubleClick = function(touches, event)
            self.__cmpControlMapper:pressKey(ETouchType.DoubleClick)
        end,
        onShaked = function(touches, event)
            self.__cmpControlMapper:pressKey(ETouchType.Shake)
        end,

    })


    --
    self:onNodeEvent("enter", function ()
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(self.__keyboardListener, self)
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(self.__touchAllListener, self)
        self:scheduleUpdateWithPriorityLua(self.update,0)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.CCDispatcher:removeEventListener(self.__keyboardListener)
        THSTG.CCDispatcher:removeEventListener(self.__touchAllListener)
        self:unscheduleUpdate()
    end)
end

function Player:shot()

end

function Player:move()

end

function Player:setPos(x,y)

end

function Player:update()
end

----
local function createUI()
    -------Model-------
   
    -------View-------
    local node = THSTG.UI.newNode()

    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node

end

----
function M.create(params)
    --------

    local _player = Player:create()
    local _scheduledTask = THSTG.COMMON.newScheduledTask()
    --------

    --------




end

return M