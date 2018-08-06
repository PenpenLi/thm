module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

    --一个ScrollView
    local sv2 = THSTG.UI.newScrollView({
        x = 500, y = 310,
        width = 200, height = 200,
        innerWidth = 300, innerHeight = 300,
        bounceEnabled = false,
        anchorPoint = THSTG.UI.POINT_CENTER,
        direction = ccui.ScrollViewDir.vertical,
        style = {
            bgColor = THSTG.UI.COLOR_WHITE,
        }
    })
    layer:addChild(sv2)

    local btnSv1 = THSTG.UI.newButton({
        x = 50,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        isTouchAction = false,
        style = {
            normal ={
                skin = {src = "res/close.png"}
            },
            selected = {
                skin = {src = "res/open.png"}
            },
        }
    })
    sv2:addChild(btnSv1)


    return layer
end
return M