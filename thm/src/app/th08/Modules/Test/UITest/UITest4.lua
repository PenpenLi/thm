module(..., package.seeall)
local EGameKeyType = Messages.Public.EGameKeyType
local M = {}
function M.create(params)
    -------Model-------
    local STEP_KEY_VAL = 2
    local STEP_TOUCH_VAL = 5
    local _uiPlayer = nil
    local _varKeyboardListener = nil
    local _varTouchAllListener = nil

    local _varMoveStep = {x = 0,y = 0}

    local _varDestPos = false
  
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
    node:addChild(_uiPlayer)

    -------Controller-------
    local _varKeyToTypeMap = {}
    -- local _varTypeToKeyMap = {}
    local _varCountChache = {}
    local function registerKey(keyCode,keyType)
        _varKeyToTypeMap[keyCode] = keyType
        -- _varTypeToKeyMap[keyType] = _varTypeToKeyMap[keyType] or {}
        -- _varTypeToKeyMap[keyType][keyCode] = 0
    end
    local function resetAllKeys()
        _varCountChache = {}
    end

    local function resetKey(type)
        _varCountChache[type] = 0
    end
    local function isKeyDown(type)
        return _varCountChache[type] and _varCountChache[type] > 0
    end
    local function pressKey(keyCode)
        local keyType = _varKeyToTypeMap[keyCode]
        if keyType then _varCountChache[keyType] = (_varCountChache[keyType] or 0) + 1 end
    end
    local function pressKeyOnce(keyCode)
        local keyType = _varKeyToTypeMap[keyCode]
        if not isKeyDown(keyType) then
            pressKey(keyCode)
        end
    end
    local function releaseKey(keyCode)
        local keyType = _varKeyToTypeMap[keyCode]
        if keyType then _varCountChache[keyType] = math.max((_varCountChache[keyType] or 0) - 1,0) end
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
           
        end
    end

    local function playerWipeHandle()
        if isKeyDown(EGameKeyType.Wipe) then
            print(15,"擦弹")
        end
        
    end

    local function playerSkillHandle()
        if isKeyDown(EGameKeyType.Skill) then
            print(15,"SpellCard")



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
            pressKeyOnce("TouchSkill")
        end,
        onShaked = function(touches, event)
            pressKeyOnce("TouchWipe")
        end,
        onLongClick = function(touches, event)
            -- print(15,"长按")
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