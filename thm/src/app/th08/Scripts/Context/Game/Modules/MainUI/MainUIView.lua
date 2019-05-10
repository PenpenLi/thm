module(..., package.seeall)

local M = class("MainUIView", THSTG.MVC.View)

function M:ctor()
    M.super.ctor(self)
   
    self._hudView = false
end

function M:_onInit()


end

function M:_onRealView()
    local node = THSTG.SCENE.newLayer()
    node:addTo(THSTG.SceneManager.get(SceneType.MAIN).mianUILayer)

    self._hudView = require("Scripts.Context.Game.Modules.MainUI.MainUIHUD").create()
    node:addChild(self._hudView)

    return node
end

return M