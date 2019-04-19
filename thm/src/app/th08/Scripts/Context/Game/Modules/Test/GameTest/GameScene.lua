module(..., package.seeall)
local EGameKeyType = GameDef.Public.EGameKeyType
local ETouchExType = THSTG.DEFINITION.ETouchExType
local Player = require("Scripts.Context.Game.Modules.Test.GameTest.Misc.Player")
local Scenario = require("Scripts.Context.Game.Modules.Test.GameTest.Misc.Scenario")
local M = {}
function M.create(params)
    -------Model-------
    --键盘与触屏移动只能同时一个
    local STEP_KEY_VAL = 2
    local STEP_TOUCH_VAL = 2


    local _varKeyboardListener = nil
    local _varTouchAllListener = nil

    local _varMoveStep = {x = 0,y = 0}
    local _varDestPos = false

    local _cmpControlMapper = THSTG.UTIL.newControlMapper()
    local _cmpPlayer = Player:create()
    local _scheduledTask = THSTG.UTIL.newTaskScheduler()
    -------View-------
    local node = THSTG.UI.newNode()
    node:addChild(_cmpPlayer)

    _scheduledTask:setTasks(Scenario)
    _scheduledTask:setUserData({node = node})

    -------Controller-------
    local function initKeyRegister()
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_W,EGameKeyType.MoveUp)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_UP_ARROW,EGameKeyType.MoveUp)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_S,EGameKeyType.MoveDown)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_DOWN_ARROW,EGameKeyType.MoveDown)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_A,EGameKeyType.MoveLeft)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_LEFT_ARROW,EGameKeyType.MoveLeft)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_D,EGameKeyType.MoveRight)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_RIGHT_ARROW,EGameKeyType.MoveRight)
    
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_Z,EGameKeyType.Attack)
        _cmpControlMapper:registerKey(ETouchExType.OnceClick,EGameKeyType.Attack)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_H,EGameKeyType.Attack)
    
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_X,EGameKeyType.Wipe)
        _cmpControlMapper:registerKey(ETouchExType.Shake,EGameKeyType.Wipe)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_J,EGameKeyType.Wipe)
    
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_C,EGameKeyType.Bomb)
        _cmpControlMapper:registerKey(ETouchExType.DoubleClick,EGameKeyType.Bomb)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_K,EGameKeyType.Bomb)

        _cmpControlMapper:registerKey(ETouchExType.MultiTouch,EGameKeyType.Slow)
        _cmpControlMapper:registerKey(cc.KeyCode.KEY_SHIFT,EGameKeyType.Slow)
    end

    ---
    local function playerKeyMoveHandle()
        if _cmpControlMapper:isKeyDown(EGameKeyType.MoveLeft) then
            _varMoveStep.x = -STEP_KEY_VAL
        end
        if _cmpControlMapper:isKeyDown(EGameKeyType.MoveRight) then
            _varMoveStep.x = STEP_KEY_VAL
        end
        if _cmpControlMapper:isKeyDown(EGameKeyType.MoveUp) then
            _varMoveStep.y = STEP_KEY_VAL
        end
        if _cmpControlMapper:isKeyDown(EGameKeyType.MoveDown) then
            _varMoveStep.y = -STEP_KEY_VAL
        end
        _cmpPlayer:move(_varMoveStep.x,_varMoveStep.y)
    end

    local function playerTouchMoveHandle()
        if _varDestPos then
            local curPos = cc.p(_cmpPlayer:getPosition())
            local destPos = cc.p(_varDestPos.x,_varDestPos.y)
            local shift = cc.pSub(destPos, curPos) 
            local length = cc.pGetLength(shift)
            if length <= STEP_TOUCH_VAL then
                _cmpPlayer:setPos(destPos)
            else
                local angle = cc.pGetAngle(cc.p(1,0),shift)
                local offesetX = STEP_TOUCH_VAL * math.cos(angle)
                local offesetY = STEP_TOUCH_VAL * math.sin(angle)
                _cmpPlayer:move(offesetX,offesetY)
            end
        end
    end


    local function playerHitHandle()
        if _cmpControlMapper:isKeyDown(EGameKeyType.Attack) then
            -- print(15,"攻击")
            _cmpPlayer:shot(node)
        end
    end

    local function playerWipeHandle()
        --一方面是因为要检查是否按了开启按键,另一方面还要检查时间
        _cmpPlayer:wipe(_cmpControlMapper:isKeyDown(EGameKeyType.Wipe))
    end

    local function playerSkillHandle()
        if _cmpControlMapper:isKeyDown(EGameKeyType.Bomb) then

            _cmpPlayer:skill()
            _cmpControlMapper:resetKey(EGameKeyType.Bomb)
        end
    end

    local function playerSlowHandle()
        if _cmpControlMapper:isKeyDown(EGameKeyType.Slow) then
            print(15,"低速模式")
            _cmpControlMapper:resetKey(EGameKeyType.Slow)
        end
    end

    local function playerMoveHandle()
        --TODO:同一个方向的移动只能有一次
        playerKeyMoveHandle()
        playerTouchMoveHandle()

    end

    
    local function playerActionHandle()
        playerHitHandle()
        playerWipeHandle()
        playerMoveHandle()
        playerSkillHandle()
        playerSlowHandle()
    end
    ----------

    local function exitGame()

    end


    ---------
    _varKeyboardListener = THSTG.EVENT.newKeyboardExListener({
        onPressed = function (keyCode, event)
            _cmpControlMapper:pressKey(keyCode)
        end,

        onReleased = function(keyCode, event)
            _cmpControlMapper:releaseKey(keyCode)
            _varMoveStep = {x = 0,y = 0}
        end,

    })


    _varTouchAllListener = THSTG.EVENT.newTouchAllAtOnceExListener({
        onBegan = function(touches, event)
            --有触屏就有攻击
            local curPos = touches[1]:getLocation()
            _varDestPos = {x = curPos.x, y = curPos.y}
            _cmpControlMapper:pressKey(ETouchExType.OnceClick)
            return true
        end,
        onMoved = function(touches, event)
            local curPos = touches[1]:getLocation()
            _varDestPos = {x = curPos.x, y = curPos.y}
            if #touches > 1 then
                _cmpControlMapper:pressKey(ETouchExType.MultiTouch)
            end
        end,
        onEnded = function(touches, event)
            _varDestPos = false
            _cmpControlMapper:releaseKey(ETouchExType.OnceClick)
            _cmpControlMapper:releaseKey(ETouchExType.Shake)
            _cmpControlMapper:releaseKey(ETouchExType.DoubleClick)
        end,
        --
        onDoubleClick = function(touches, event)
            _cmpControlMapper:pressKey(ETouchExType.DoubleClick)
        end,
        onShaked = function(touches, event)
            _cmpControlMapper:pressKey(ETouchExType.Shake)
        end,

    })

    local function updateFrame()
        playerActionHandle()
        _scheduledTask:poll()
    end




    node:onNodeEvent("enter", function ()
        initKeyRegister()
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