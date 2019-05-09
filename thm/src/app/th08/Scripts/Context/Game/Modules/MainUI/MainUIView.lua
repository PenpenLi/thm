module(..., package.seeall)

local M = class("MainUIView", THSTG.MVC.View)

function M:ctor()
    M.super.ctor(self)
   
end

function M:_onInit()


end

function M:_onRealView()
    local node = THSTG.SCENE.newLayer()
    node:addTo(THSTG.SceneManager.get(SceneType.MAIN).mianUILayer)

    return node
end

return M