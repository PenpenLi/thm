local M = class("StageScene",function ()
    -- return THSTG.PHYSICS.newPhysicsScene({  --拥有物理引擎的场景
    --     isHaveEdge = false,
    --     drawMask = cc.PhysicsWorld.DEBUGDRAW_ALL,
    -- })
    return cc.Scene:create()
end)

function M:ctor()

    --背景层
    self.backgroundLayer = cc.Layer:create()
    --后置特效层
    self.backEffectLayer = cc.Layer:create()
    --实体层
    self.entityLayer = cc.Layer:create()
    --主角层
    self.playerLayer = cc.Layer:create()
    --弹幕层
    self.barrageLayer = cc.Layer:create()
    --前置特效层
    self.preEffectLayer = cc.Layer:create()
    --主体UI层
    self.mainLayer = cc.Layer:create()
    --弹窗层
    self.windowLayer = cc.Layer:create()


    self:addChild(self.backgroundLayer)
    self:addChild(self.backEffectLayer)
    self:addChild(self.entityLayer)
    self:addChild(self.playerLayer)
    self:addChild(self.barrageLayer)
    self:addChild(self.preEffectLayer)
    self:addChild(self.mainLayer)
    self:addChild(self.windowLayer)
    --
    self:onNodeEvent("enter", function ()
        THSTG.MVCManager.openModule(ModuleType.STAGE)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.MVCManager.closeModule(ModuleType.STAGE)
    end)
end




return M