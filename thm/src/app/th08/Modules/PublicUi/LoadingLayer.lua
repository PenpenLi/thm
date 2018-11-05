module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------

    -------View-------
    local node = THSTG.UI.newNode()

    --背景
    local mainBg = THSTG.UI.newImage({
        x = display.cx,
        y = display.cy,
        anchorPoint= THSTG.UI.POINT_CENTER,
        source = ResManager.getRes(ResType.PUBLIC_UI,"loading_logo")
    })
    node:addChild(mainBg)
    --加载动画



    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node
end

return M