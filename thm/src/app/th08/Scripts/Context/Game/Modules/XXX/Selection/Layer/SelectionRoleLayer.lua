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
            if not _varIsEnabled then return end

            _slideLeftHandle()
        end,
        slideRight = function ()
            if not _varIsEnabled then return end

            _slideRightHandle()
        end,
    })
    node:addChild(slideLayer)

    display.newSprite("HelloWorld.png")
    :move(display.center)
    :addTo(node)
    --------Control--------
    local function leftSelect()
        print(15,":left")
    end

    local function rightSelect()
        print(15,":right")
    end


    _slideLeftHandle = function ()
        leftSelect()
    end
    _slideRightHandle = function ()
        rightSelect()
    end

    _varKeyboardListener = THSTG.EVENT.newKeyboardListener({
        onPressed = function (keyCode, event)
            if not _varIsEnabled then return end
            if keyCode == cc.KeyCode.KEY_ESCAPE then
                --返回上层的动画
                Dispatcher.dispatchEvent(EventType.STARTITEM_SELECTROLE_CANCEL)

            end
           
        end,
    })


    function node:setEnabled(status)
        _varIsEnabled = status
    end

    node:onNodeEvent("enter", function ()
        THSTG.CCEventDispatcher:addEventListenerWithSceneGraphPriority(_varKeyboardListener, node)
	end)

    node:onNodeEvent("exit", function ()
        THSTG.CCEventDispatcher:removeEventListener(_varKeyboardListener)
    end)

    return node
end
return M