module(..., package.seeall)
local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local STEP_KEY_VAL = 2
local M = {}

local Player = class("Player",cc.Node)

function Player:ctor()
    self._controlMapper = false

    self._entity = StageDefine.PlayerEntity:create()

    self:setAnchorPoint(cc.p(0.5,0.5))
    self:setContentSize(cc.size(40,40))
    self:setPosition(cc.p(0,0))

    self._mainSprite = cc.Sprite:create()
    self._mainSprite:setAnchorPoint(cc.p(0.5,0.5))
    self._mainSprite:setPosition(cc.p(self:getContentSize().width,self:getContentSize().height))
    self:addChild(self._mainSprite)

    debugUI(self)

    local function updateFrame()
        self:__update()
    end
    self:scheduleUpdateWithPriorityLua(updateFrame,0)

    self:_onInit()
end

function Player:setControlMapper(mapper)
    self._controlMapper = mapper
end

function Player:getControlMapper()
    return self._controlMapper
end

function Player:moveBy(x,y)

    local oldX,oldY = self:getPosition()
    self:setPosition(cc.p(oldX+x,oldY+y))

end

function Player:setAnimation(key)

end

function Player:shot()
   
end

---
function Player:_onInit()
    
end

function Player:_onInput(input)
    --这里如果有状态机的话就太麻烦了,只有移动的时候需要判断上一个状态
    local function moveHandle()
        --细分状态:移动的各个状态是互斥的
        local moveStep = cc.p(0,0)
        if input:isKeyDown(EGameKeyType.MoveLeft) then
            moveStep.x = -STEP_KEY_VAL
        end
        if input:isKeyDown(EGameKeyType.MoveRight) then
            moveStep.x = STEP_KEY_VAL
        end
        if input:isKeyDown(EGameKeyType.MoveUp) then
            moveStep.y = STEP_KEY_VAL
        end
        if input:isKeyDown(EGameKeyType.MoveDown) then
            moveStep.y = -STEP_KEY_VAL
        end

        self:moveBy(moveStep.x,moveStep.y)
        if moveStep.x == 0 and moveStep.y == 0 then
            self:setAnimation("stand")
        else
            self:setAnimation("move")
        end
        
    end

    local function shotHandle()
        if input:isKeyDown(EGameKeyType.Attack) then
            self:shot()
            self:setAnimation("shot")
        end
    end

    local function skillHandle()
        if input:isKeyDown(EGameKeyType.Bomb) then
            self:setAnimation("skill")
        end
    end

    if input then
        --下面的状态是并发的
        moveHandle()
        shotHandle()
        skillHandle()
    end
end

function Player:__update()
   self:_onInput(self:getControlMapper())
end

---------------------------------------
---------------------------------------
---------------------------------------
---------------------------------------
function M.create(params)
    -------Model-------
    local _cmpControlMapper = THSTG.UTIL.newControlMapper()
    local _cmpPlayer= Player:create()

    local _varKeyboardListener = nil
    local _varTouchAllListener = nil
    -------View-------
    local node = THSTG.UI.newNode()
    node:addChild(_cmpPlayer)
  
    -------Controller-------
    _varKeyboardListener = EventPublic.newKeyboardExListener({
        onPressed = function (keyCode, event)
            _cmpControlMapper:pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            _cmpControlMapper:releaseKey(keyCode)
        end,

    })

    _varTouchAllListener = EventPublic.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
          
            _cmpControlMapper:pressKey(ETouchType.OnceClick)
            return true
        end,
        onMoved = function(touches, event)
            if #touches > 1 then
                _cmpControlMapper:pressKey(ETouchType.MultiTouch)
            end
        end,
        onEnded = function(touches, event)
            _cmpControlMapper:releaseKey(ETouchType.OnceClick)
            _cmpControlMapper:releaseKey(ETouchType.Shake)
            _cmpControlMapper:releaseKey(ETouchType.DoubleClick)
            if #touches > 1 then
                _cmpControlMapper:releaseKey(ETouchType.MultiTouch)
            end
        end,
        onDoubleClick = function(touches, event)
            _cmpControlMapper:pressKey(ETouchType.DoubleClick)
        end,
        onShaked = function(touches, event)
            _cmpControlMapper:pressKey(ETouchType.Shake)
        end,

    })

    --按键登记
    local function initKeyRegisters()
        _cmpControlMapper:clear()
        --TODO:取得设置的按键映射

        _cmpControlMapper:registerKey(cc.KeyCode.KEY_W,EGameKeyType.MoveUp)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_UP_ARROW,EGameKeyType.MoveUp)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_S,EGameKeyType.MoveDown)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_DOWN_ARROW,EGameKeyType.MoveDown)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_A,EGameKeyType.MoveLeft)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_LEFT_ARROW,EGameKeyType.MoveLeft)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_D,EGameKeyType.MoveRight)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_RIGHT_ARROW,EGameKeyType.MoveRight)
    
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_Z,EGameKeyType.Attack)
        _cmpControlMapper:registerKey(ETouchType.OnceClick,EGameKeyType.Attack)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_H,EGameKeyType.Attack)
    
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_X,EGameKeyType.Wipe)
        _cmpControlMapper:registerKey(ETouchType.Shake,EGameKeyType.Wipe)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_J,EGameKeyType.Wipe)
    
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_C,EGameKeyType.Bomb)
        _cmpControlMapper:registerKey(ETouchType.DoubleClick,EGameKeyType.Bomb)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_K,EGameKeyType.Bomb)

        _cmpControlMapper:registerKey(ETouchType.MultiTouch,EGameKeyType.Slow)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_SHIFT,EGameKeyType.Slow)
    end

    local function initPlayerData()
        _cmpPlayer:setPosition(cc.p(display.cx,display.cy))
        _cmpPlayer:setControlMapper(_cmpControlMapper)
    end

    local function updateFrame()

    end

    node:onNodeEvent("enter", function ()
        initKeyRegisters()
        initPlayerData()
        node:scheduleUpdateWithPriorityLua(updateFrame,0)
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varKeyboardListener, node)
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varTouchAllListener, node)
    end)

    node:onNodeEvent("exit", function ()
        node:unscheduleUpdate()
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
        THSTG.CCDispatcher:removeEventListener(_varTouchAllListener)
    end)
    
    return node
end

return M