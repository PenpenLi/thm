module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
    local ROLES_INFO = {
        {mode = 1,}
    }

    local _ui = {}

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


    --------Control--------
    _slideLeftHandle = function ()
        print(15,":left")
    end
    _slideRightHandle = function ()
        print(15,":right")
    end

    node:onNodeEvent("enter", function ()
       
	end)

	node:onNodeEvent("exit", function ()
        
    end)

    return node
end
return M