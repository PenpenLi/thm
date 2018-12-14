module(..., package.seeall)
local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local M = class("Reimu",StageDefine.PlayerEntity)

function M:ctor()
    M.super.ctor(self)
    
    --刚体组件
    self._rigidbody = cc.rect(0,0,20,20)
    --动画组件
    self._mianSprite = THSTG.SCENE.newSprite()
    --输入组件
    self._cKeyboardListener = nil
    self._cTouchAllListener = nil
    --按键映射器
    self._cControlMapper = THSTG.UTIL.newControlMapper()

    --
    self:_initSelf()
    self:_initSprite()
    self:_initKeyRegisters()
    self:_initKeyListener()
end

function M:_initSelf()
    local size = cc.size(self._rigidbody.width,self._rigidbody.height)
    self:setContentSize(size)
end

function M:_initSprite()
    self._mianSprite:setAnchorPoint(cc.p(0.5,0.5))
    self._mianSprite:setContentSize(self:getContentSize())
    self._mianSprite:setPositionX(self:getContentSize().width/2)
    self._mianSprite:setPositionY(self:getContentSize().height/2)
    self:addChild(self._mianSprite)
    debugUI(self._mianSprite)
end

function M:_initKeyRegisters()
    --映射按键注册
    self._cControlMapper:clear()

    self._cControlMapper:registerKey(cc.KeyCode.KEY_W,EGameKeyType.MoveUp)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_UP_ARROW,EGameKeyType.MoveUp)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_S,EGameKeyType.MoveDown)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_DOWN_ARROW,EGameKeyType.MoveDown)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_A,EGameKeyType.MoveLeft)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_LEFT_ARROW,EGameKeyType.MoveLeft)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_D,EGameKeyType.MoveRight)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_RIGHT_ARROW,EGameKeyType.MoveRight)

    self._cControlMapper:registerKey(cc.KeyCode.KEY_Z,EGameKeyType.Attack)
    self._cControlMapper:registerKey(ETouchType.OnceClick,EGameKeyType.Attack)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_H,EGameKeyType.Attack)

    self._cControlMapper:registerKey(cc.KeyCode.KEY_X,EGameKeyType.Wipe)
    self._cControlMapper:registerKey(ETouchType.Shake,EGameKeyType.Wipe)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_J,EGameKeyType.Wipe)

    self._cControlMapper:registerKey(cc.KeyCode.KEY_C,EGameKeyType.Skill)
    self._cControlMapper:registerKey(ETouchType.DoubleClick,EGameKeyType.Skill)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_K,EGameKeyType.Skill)

    self._cControlMapper:registerKey(ETouchType.MultiTouch,EGameKeyType.Slow)
    self._cControlMapper:registerKey(cc.KeyCode.KEY_SHIFT,EGameKeyType.Slow)
end

function M:_initKeyListener()
    self._cKeyboardListener = EventPublic.newKeyboardExListener({
        onPressed = function (keyCode, event)
            self._cControlMapper:pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            self._cControlMapper:releaseKey(keyCode)
        end,
    })

    self._cTouchAllListener = EventPublic.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            self._cControlMapper:pressKey(ETouchType.OnceClick)
            return true
        end,
        onMoved = function(touches, event)
            if #touches > 1 then
                self._cControlMapper:pressKey(ETouchType.MultiTouch)
            end
        end,
        onEnded = function(touches, event)
            self._cControlMapper:releaseKey(ETouchType.OnceClick)
            self._cControlMapper:releaseKey(ETouchType.Shake)
            self._cControlMapper:releaseKey(ETouchType.DoubleClick)
            if #touches > 1 then
                self._cControlMapper:releaseKey(ETouchType.MultiTouch)
            end
        end,
        onDoubleClick = function(touches, event)
            self._cControlMapper:pressKey(ETouchType.DoubleClick)
        end,
        onShaked = function(touches, event)
            self._cControlMapper:pressKey(ETouchType.Shake)
        end,

    })
end

---
--这里如果有状态机的话就太麻烦了,只有移动的时候需要判断上一个状态
local function moveHandle(self)
    --细分状态:移动的各个状态是互斥的
    local input = self._cControlMapper
    local moveStep = cc.p(0,0)
    if input:isKeyDown(EGameKeyType.MoveLeft) then
        moveStep.x = -Definition.Public.PLAYER_MOVE_STEP
    end
    if input:isKeyDown(EGameKeyType.MoveRight) then
        moveStep.x = Definition.Public.PLAYER_MOVE_STEP
    end
    if input:isKeyDown(EGameKeyType.MoveUp) then
        moveStep.y = Definition.Public.PLAYER_MOVE_STEP
    end
    if input:isKeyDown(EGameKeyType.MoveDown) then
        moveStep.y = -Definition.Public.PLAYER_MOVE_STEP
    end
    local oldX,oldY = self:getPosition()
    self:setPosition(cc.p(oldX+moveStep.x,oldY+moveStep.y))
end

local function shotHandle(self)
    local input = self._cControlMapper
    if input:isKeyDown(EGameKeyType.Attack) then
        self:shot()
        
    end
end

local function skillHandle(self)
    local input = self._cControlMapper
    if input:isKeyDown(EGameKeyType.Skill) then
        
    end
end
---
function M:_onEnter()
    THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(self._cKeyboardListener, self)
    THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(self._cTouchAllListener, self)
end

function M:_onExit()
    THSTG.CCDispatcher:removeEventListener(self._cKeyboardListener)
    THSTG.CCDispatcher:removeEventListener(self._cTouchAllListener)
end

function M:_onUpdate(dTime)
    moveHandle(self)
    shotHandle(self)
    skillHandle(self)
end

return M