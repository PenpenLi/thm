local M = class("MainScene",function ()
    return THSTG.PHYSICS.newPhysicsScene({  --拥有物理引擎的场景
        isHaveEdge = false,
        drawMask = __PHYSICS_DEBUG_MASK__,
    })
    -- return cc.Scene:create()
end)

function M:ctor()
    --------Ex层--------
    self.bottomLayer = cc.Layer:create()--最底层
    --------Stage层--------
    self.backgroundLayer = cc.Layer:create()--背景层
    self.backEffectLayer = cc.Layer:create()--后置特效层
    self.playerLayer = cc.Layer:create()--主角层
    self.barrageLayer = cc.Layer:create()--弹幕层
    self.preEffectLayer = cc.Layer:create()--前置特效层
    self.hudLayer = cc.Layer:create()--HUD层
    --------UI层--------
    self.backUILayer = cc.Layer:create()--UI底层
    self.mainUILayer = cc.Layer:create()--UI层
    self.windowLayer = cc.Layer:create()--弹窗层
    --------Ex层--------
    self.topLayer = cc.Layer:create()--最顶层


    self:addChild(self.bottomLayer)
    self:addChild(self.backgroundLayer)
    self:addChild(self.backEffectLayer)
    self:addChild(self.playerLayer)
    self:addChild(self.barrageLayer)
    self:addChild(self.preEffectLayer)
    self:addChild(self.hudLayer)
    --
    self:addChild(self.backUILayer)
    self:addChild(self.mainUILayer)
    self:addChild(self.windowLayer)
    self:addChild(self.topLayer)
    --
    self:onNodeEvent("enter", function ()
        THSTG.MVCManager.openModule(ModuleType.STAGE)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.MVCManager.closeModule(ModuleType.STAGE)
    end)
end

return M