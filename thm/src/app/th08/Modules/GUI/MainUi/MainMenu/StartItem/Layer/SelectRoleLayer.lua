module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
    local ROLES_INFO = {
        {mode = 1,}
    }

    local _ui = {}
    local _varKeyboardListener = nil
    local _slideLeftHandle = nil
    local _slideRightHandle = nil
    --------View--------
    local node = THSTG.UI.newWidget()

    --需要一个能够判断滑动方向的View
    local slideLayer = THSTG.UI.newLayerGesture({
        showColor = false,
        slideLeft = function ()
            _slideLeftHandle()
        end,
        slideRight = function ()
            _slideRightHandle()
        end,
    })
    node:addChild(slideLayer)

    display.newSprite("HelloWorld.png")
    :move(display.center)
    :addTo(node)
    --------Control--------
    _slideLeftHandle = function ()
        print(15,":left")
    end
    _slideRightHandle = function ()
        print(15,":right")
    end

    _varKeyboardListener = THSTG.EVENT.newKeyboardListener({
        onPressed = function (keyCode, event)
            if _varIsEnabled then
                if keyCode == cc.KeyCode.KEY_ESCAPE then
                    --返回上层的动画
                    THSTG.Dispatcher.dispatchEvent(EventType.STARTITEM_SELECTROLE_CANCEL)

                end
            end
        end,
    })


    function node:setEnabled(status)
        _varIsEnabled = status
        slideLayer:setEnabled(status)
    end

    node:onNodeEvent("enter", function ()
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(_varKeyboardListener, node)
	end)

    node:onNodeEvent("exit", function ()
        print(15,"dsdsdsdsExit")
        THSTG.CCDispatcher:removeEventListener(_varKeyboardListener)
    end)

    return node
end
return M