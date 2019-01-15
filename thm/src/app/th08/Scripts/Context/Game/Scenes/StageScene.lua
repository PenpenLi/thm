local M = class("StageScene",cc.Scene)

function M:ctor()
    --背景层
    self.backgroundLayer = cc.Layer:create()
    --实体层
    self.entityLayer = cc.Layer:create()
    --主角层
    self.playerLayer = cc.Layer:create()
    --弹幕层
    self.barrageLayer = cc.Layer:create()
    --主体UI层
    self.mainLayer = cc.Layer:create()
    --弹窗层
    self.windowLayer = cc.Layer:create()


    
    self:addChild(self.backgroundLayer)
    self:addChild(self.barrageLayer)
    self:addChild(self.entityLayer)
    self:addChild(self.playerLayer)
    self:addChild(self.mainLayer)
    self:addChild(self.windowLayer)
    --
    self:onNodeEvent("enter", function ()
        THSTG.ModuleManager.open(ModuleType.STAGE)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.ModuleManager.close(ModuleType.STAGE)
    end)
end




return M