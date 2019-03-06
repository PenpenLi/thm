local M = class("MainScene",cc.Scene)

function M:ctor()
    --
    self.background = cc.Layer:create()
    --UI层
    self.mainUILayer = cc.Layer:create()
    --弹窗层
    self.windowLayer = cc.Layer:create()
    --最顶层
    self.topLayer = cc.Layer:create()


    self:addChild(self.background)
    self:addChild(self.mainUILayer)
    self:addChild(self.windowLayer)
    self:addChild(self.topLayer)
    --
    self:onNodeEvent("enter", function ()
        THSTG.MVCManager.openModule(ModuleType.TEST)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.MVCManager.closeModule(ModuleType.TEST)
    end)
end



return M