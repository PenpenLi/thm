local M = class("StartScene", View)

function M:onCreate()

    --背景图
    local mainBg = THSTG.UI.newImage({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getRes(ResType.MAIN_SCENE, "") --TODO:

    })

end

return M