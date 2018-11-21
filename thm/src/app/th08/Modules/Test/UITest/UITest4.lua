module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local STEP_KEY_VAL = 2
    local STEP_TOUCH_VAL = 5
    local _uiPlayer = nil
    local _varKeyboardListener = nil
    local _varTouchAllListener = nil

    local _varKeyCahce = {}
    local _varMoveStep = {x = 0,y = 0}

    local _varDestPos = false
    local GAME_KEY = {
        [cc.KeyCode.KEY_W] = Enums.EGameKeyType.MoveUp,
        [cc.KeyCode.KEY_S] = Enums.EGameKeyType.MoveDown,
        [cc.KeyCode.KEY_A] = Enums.EGameKeyType.MoveLeft,
        [cc.KeyCode.KEY_D] = Enums.EGameKeyType.MoveRight,

        [cc.KeyCode.KEY_UP_ARROW] = Enums.EGameKeyType.MoveUp,
        [cc.KeyCode.KEY_DOWN_ARROW] = Enums.EGameKeyType.MoveDown,
        [cc.KeyCode.KEY_LEFT_ARROW] = Enums.EGameKeyType.MoveLeft,
        [cc.KeyCode.KEY_RIGHT_ARROW] = Enums.EGameKeyType.MoveRight,

        [cc.KeyCode.KEY_Z] = Enums.EGameKeyType.Attack,
        ["TouchAttack"] = Enums.EGameKeyType.Attack,

        [cc.KeyCode.KEY_X] = Enums.EGameKeyType.Wipe,
        ["TouchWipe"] = Enums.EGameKeyType.Wipe,

        [cc.KeyCode.KEY_C] = Enums.EGameKeyType.Skill,
        ["TouchSkill"] = Enums.EGameKeyType.Skill,

    }
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
    local function isKeyDown(state)
        return _varKeyCahce[state] and _varKeyCahce[state] > 0
    end
    local function pressKey(keyCode)
        local key = GAME_KEY[keyCode]
        if key then _varKeyCahce[key] = (_varKeyCahce[key] or 0) + 1 end
    end
    local function releaseKey(keyCode)
        local key = GAME_KEY[keyCode]
        if key then _varKeyCahce[key] = (_varKeyCahce[key] or 0) - 1 end
    end

    local function playerKeyMoveHandle()
        if isKeyDown(Enums.EGameKeyType.MoveLeft) then

            _varMoveStep.x = -STEP_KEY_VAL
        end
        if isKeyDown(Enums.EGameKeyType.MoveRight) then

            _varMoveStep.x = STEP_KEY_VAL
        end
        if isKeyDown(Enums.EGameKeyType.MoveUp) then

            _varMoveStep.y = STEP_KEY_VAL
        end
        if isKeyDown(Enums.EGameKeyType.MoveDown) then

            _varMoveStep.y = -STEP_KEY_VAL
        end
        _uiPlayer:setPositionX(_uiPlayer:getPositionX()+_varMoveStep.x)
        _uiPlayer:setPositionY(_uiPlayer:getPositionY()+_varMoveStep.y)
    end

    local function playerHitHandle()
        if isKeyDown(Enums.EGameKeyType.Attack) then
            -- print(15,"攻击")
           
        end
    end

    local function playerWipeHandle()
        if isKeyDown(Enums.EGameKeyType.Wipe) then
            print(15,"擦弹")
        end
        
    end

    local function playerSkillHandle()
        if isKeyDown(Enums.EGameKeyType.Skill) then
            print(15,"SpellCard")
        end
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
    ----------

    local function exitGame()

    end


    ---------
    _varKeyboardListener = EventPublic.newKeyboardExListener({
        onPressed = function (keyCode, event)
            pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            if isKeyDown(Enums.EGameKeyType.Skill) then
                playerSkillHandle()
            -- elseif isKeyDown(Enums.EGameKeyType.Wipe) then
            --     playerWipeHandle()
            end
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
        end,
        --
        onDoubleClick = function(touches, event)
            pressKey("TouchSkill")
            playerSkillHandle()
        end,
        onShaked = function(touches, event)
            --TODO:
            if not isKeyDown(Enums.EGameKeyType.Wipe) then
                pressKey("TouchWipe")
            end
            -- playerWipeHandle()
        end,
        onLongClick = function(touches, event)
            -- print(15,"长按")
        end,

    })

    local function updateFrame()
        playerHitHandle()
        playerWipeHandle()
        playerKeyMoveHandle()
        playerTouchMoveHandle()
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