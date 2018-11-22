module(..., package.seeall)
local EGameKeyType = Messages.Public.EGameKeyType
local M = {}
function M.create(params)
    -------Model-------
    local STEP_KEY_VAL = 2
    local STEP_TOUCH_VAL = 10
    local _uiPlayer = nil
    local _varKeyboardListener = nil
    local _varTouchAllListener = nil

    local _varMoveStep = {x = 0,y = 0}

    local _varDestPos = false
    local _cmpControlMapper = THSTG.COMMON.newControlMapper()
  
    -------View-------
    local node = THSTG.UI.newNode()


    _uiPlayer = THSTG.UI.newNode({
        x = display.cx,
        y = display.cy,
        width = 40,
        height = 40,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    debugUI(_uiPlayer)
    function _uiPlayer:init()
        self.__bullets = {} --缓存池
        self.__isStateWipe = false
        self.__tickClock = THSTG.COMMON.newTickClock()
        self.__isWipeEffectNode =  THSTG.UI.newNode({
            x = self:getContentSize().width/2,
            y = self:getContentSize().height/2,
            anchorPoint = THSTG.UI.POINT_CENTER,
            width = 80,
            height = 80,
        })
        self.__isWipeEffectNode:setVisible(false)
        self:addChild(self.__isWipeEffectNode)
        debugUI(self.__isWipeEffectNode)

    end

    function _uiPlayer:shot()

        if self.__tickClock:getElpased() < 150 then
            return 
        end

        --生成/或从缓存池中取出3个精灵
        local function makeAction(node)
            local actions = {}
            table.insert( actions, cc.MoveBy:create(1.0,cc.p(0,display.height)))
            table.insert( actions,cc.CallFunc:create(function ()
                node:removeFromParent()
            end))
            
            return cc.Sequence:create(actions)
        end
        --FIXME:需要一个粒子系统
        local bullet = THSTG.UI.newNode({
            x = self:getPositionX(),
            y = self:getPositionY() + self:getContentSize().height + 10,
            anchorPoint = THSTG.UI.POINT_CENTER,
            width = 5,
            height = 5,
        })

        debugUI(bullet)
        bullet:runAction(makeAction(bullet))
        node:addChild(bullet)

        self.__tickClock:resume()
    end

    function _uiPlayer:skill()
        local function makeAction(node)
            local actions = {}
            node:setScale(0)
            table.insert(actions,cc.Spawn:create({
                cc.RotateBy:create(1.0, 360),
                cc.ScaleTo:create(1.0,1),
            }))
            table.insert(actions,cc.DelayTime:create(2.0))
            table.insert(actions,cc.Spawn:create({
                cc.RotateBy:create(1.0, -360),
                cc.ScaleTo:create(1.0,0),
            }))

            table.insert(actions,cc.CallFunc:create(function ()
                node:removeFromParent()
            end))
            
            return cc.Sequence:create(actions)
        end

        local effectNode = THSTG.UI.newNode({
            x = self:getContentSize().width/2,
            y = self:getContentSize().height/2,
            anchorPoint = THSTG.UI.POINT_CENTER,
            width = 80,
            height = 80,
        })
        debugUI(effectNode)
        effectNode:runAction(makeAction(effectNode))
        self:addChild(effectNode)
    end

    function _uiPlayer:wipeOpen()
        local function makeAction(node)
            local actions = {}
            node:setScale(0)
            node:setVisible(true)
            table.insert(actions,cc.Spawn:create({
                cc.RotateBy:create(1.0, 360),
                cc.ScaleTo:create(1.0,1),
            }))
          
            return cc.Sequence:create(actions)
        end

        self.__isWipeEffectNode:stopAllActions()
        self.__isWipeEffectNode:runAction(makeAction(self.__isWipeEffectNode))

    end

    function _uiPlayer:wipeClose()
        local function makeAction(node)
            local actions = {}
            table.insert(actions,cc.Spawn:create({
                cc.RotateBy:create(1.0, -360),
                cc.ScaleTo:create(1.0,0),
            }))

            table.insert(actions,cc.CallFunc:create(function ()
                self.__isWipeEffectNode:setVisible(false)

            end))
          
            return cc.Sequence:create(actions)
        end
        self.__isWipeEffectNode:stopAllActions()
        self.__isWipeEffectNode:runAction(makeAction(self.__isWipeEffectNode))

    end


    function _uiPlayer:wipe(state)
        if self.__isStateWipe ~= state then
            if state then 
                self:wipeOpen()
            else
                self:wipeClose()
            end
        end
        self.__isStateWipe = state
    end


    function _uiPlayer:move(isShift)

    end

    function _uiPlayer:update()

    end
    _uiPlayer:init()
    node:addChild(_uiPlayer)

    -------Controller-------
   
    local function registerKey(keyCode,keyType)
        return _cmpControlMapper:registerKey(keyCode,keyType)
    end
    local function resetAllKeys()
        return _cmpControlMapper:resetAllKeys()
    end

    local function resetKey(type)
        return _cmpControlMapper:resetKey(type)
    end
    local function isKeyDown(type)
        return _cmpControlMapper:isKeyDown(type)
    end
    local function pressKey(keyCode)
        return _cmpControlMapper:pressKey(keyCode)
    end
    local function pressKeyOnce(keyCode)
        return _cmpControlMapper:pressKeyOnce(keyCode)
    end
    local function releaseKey(keyCode)
        return _cmpControlMapper:releaseKey(keyCode)
    end
    registerKey(cc.KeyCode.KEY_W,EGameKeyType.MoveUp)
    registerKey(cc.KeyCode.KEY_UP_ARROW,EGameKeyType.MoveUp)
    registerKey(cc.KeyCode.KEY_S,EGameKeyType.MoveDown)
    registerKey(cc.KeyCode.KEY_DOWN_ARROW,EGameKeyType.MoveDown)
    registerKey(cc.KeyCode.KEY_A,EGameKeyType.MoveLeft)
    registerKey(cc.KeyCode.KEY_LEFT_ARROW,EGameKeyType.MoveLeft)
    registerKey(cc.KeyCode.KEY_D,EGameKeyType.MoveRight)
    registerKey(cc.KeyCode.KEY_RIGHT_ARROW,EGameKeyType.MoveRight)
    registerKey(cc.KeyCode.KEY_Z,EGameKeyType.Attack)
    registerKey("TouchAttack",EGameKeyType.Attack)
    registerKey(cc.KeyCode.KEY_X,EGameKeyType.Wipe)
    registerKey("TouchWipe",EGameKeyType.Wipe)
    registerKey(cc.KeyCode.KEY_C,EGameKeyType.Skill)
    registerKey("TouchSkill",EGameKeyType.Skill)
    ---
    local function playerKeyMoveHandle()
        if isKeyDown(EGameKeyType.MoveLeft) then

            _varMoveStep.x = -STEP_KEY_VAL
        end
        if isKeyDown(EGameKeyType.MoveRight) then

            _varMoveStep.x = STEP_KEY_VAL
        end
        if isKeyDown(EGameKeyType.MoveUp) then

            _varMoveStep.y = STEP_KEY_VAL
        end
        if isKeyDown(EGameKeyType.MoveDown) then

            _varMoveStep.y = -STEP_KEY_VAL
        end
        _uiPlayer:setPositionX(_uiPlayer:getPositionX()+_varMoveStep.x)
        _uiPlayer:setPositionY(_uiPlayer:getPositionY()+_varMoveStep.y)
    end

    local function playerTouchMoveHandle()
        if _varDestPos then
            local curPos = cc.p(_uiPlayer:getPosition())
            local destPos = cc.p(_varDestPos.x,_varDestPos.y)
            local shift = cc.pSub(destPos, curPos) 
            local length = cc.pGetLength(shift)
            if length <= STEP_TOUCH_VAL then
                _uiPlayer:setPosition(destPos)
            else
                local angle = cc.pGetAngle(cc.p(1,0),shift)
                local offesetX = STEP_TOUCH_VAL * math.cos(angle)
                local offesetY = STEP_TOUCH_VAL * math.sin(angle)
                _uiPlayer:setPositionX(_uiPlayer:getPositionX()+offesetX)
                _uiPlayer:setPositionY(_uiPlayer:getPositionY()+offesetY)
            end
        end
    end


    local function playerHitHandle()
        if isKeyDown(EGameKeyType.Attack) then
            -- print(15,"攻击")
            _uiPlayer:shot()
        end
    end

    local function playerWipeHandle()
        --一方面是因为要检查是否按了开启按键,另一方面还要检查时间
        _uiPlayer:wipe(isKeyDown(EGameKeyType.Wipe))
    end

    local function playerSkillHandle()
        if isKeyDown(EGameKeyType.Skill) then
            print(15,"SpellCard")


            _uiPlayer:skill()
            resetKey(EGameKeyType.Skill)
        end
    end

    
    local function playerActionHandle()
        playerHitHandle()
        playerWipeHandle()
        playerKeyMoveHandle()
        playerTouchMoveHandle()
        playerSkillHandle()
    end
    ----------

    local function exitGame()

    end


    ---------
    _varKeyboardListener = EventPublic.newKeyboardExListener({
        onPressed = function (keyCode, event)
            pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            releaseKey(keyCode)
            _varMoveStep = {x = 0,y = 0}
        end,

    })


    _varTouchAllListener = EventPublic.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            --有触屏就有攻击
            local curPos = touches[1]:getLocation()
            _varDestPos = {x = curPos.x, y = curPos.y}
            pressKey("TouchAttack")
            return true
        end,
        onMoved = function(touches, event)
            local curPos = touches[1]:getLocation()
            _varDestPos = {x = curPos.x, y = curPos.y}
        end,
        onEnded = function(touches, event)
            _varDestPos = false
            releaseKey("TouchAttack")
            releaseKey("TouchWipe")
            releaseKey("TouchSkill")
        end,
        --
        onDoubleClick = function(touches, event)
            pressKey("TouchSkill")
        end,
        onShaked = function(touches, event)
            pressKey("TouchWipe")
        end,

    })

    local function updateFrame()
        playerActionHandle()
      
    end
    node:onNodeEvent("enter", function ()
         THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varKeyboardListener, node)
         THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varTouchAllListener, node)
         node:scheduleUpdateWithPriorityLua(updateFrame,0)
    end)

    node:onNodeEvent("exit", function ()
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
        THSTG.CCDispatcher:removeEventListener(_varTouchAllListener)
        node:unscheduleUpdate()
    end)

    

    
    
    return node
end

return M