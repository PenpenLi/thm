local M = class("TestView", THSTG.MVC.View)

function M:_onInit()
    self._containerView = false
    self._testStatusView = false
    self._testExampleView = false
end

function M:_onRealView()
    self._containerView = require("Scripts.Context.Game.Modules.Test.View.TestContainerView").create()
    self._containerView:addTo(THSTG.SceneManager.get(SceneType.MAIN).mainUILayer)

    self._testStatusView = require("Scripts.Context.Game.Modules.Test.View.TestStatusView").create()
    self._testStatusView:addTo(THSTG.SceneManager.get(SceneType.MAIN).mainUILayer)
end

return M