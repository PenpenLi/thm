
local M = class("MainScene",function ()
    return THSTG.PHYSICS.newPhysicsScene({  --拥有物理引擎的场景
        isHaveEdge = false,
        drawMask = __PHYSICS_DEBUG_MASK__,
    })
    -- return cc.Scene:create()
end)

function M:ctor()
    --两台摄像机
    self.uiCamera = false
    self.mapCamera = false

    --------Ex层--------
    self.bottomLayer = false        --最底层
    --------Map层--------
    self.backgroundLayer = false    --背景层
    --------UI层--------
    self.backEffectLayer = false    --后置特效层
    self.playerLayer = false        --主角层
    self.barrageLayer = false       --弹幕层
    self.preEffectLayer = false     --前置特效层
    self.hudLayer = false           --HUD层

    self.backUILayer = false        --UI底层
    self.mainUILayer = false        --UI层
    self.windowLayer = false        --弹窗层
    --------Ex层--------
    self.topLayer = false           --最顶层

    -- self:_onInitCamera()         --Cocos的Camera着实让人恶心   
    self:_onInitLayer()
    self:_onInitCallback()
end

function M:_onInitCamera()
    --三台摄像机
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    self.uiCamera = cc.Camera:create()
    self.mapCamera = cc.Camera:create()

    self.uiCamera:initDefault()
    self.uiCamera:setCameraFlag(cc.CameraFlag.USER1)
    self.uiCamera:setDepth(cc.CameraFlag.USER1)
    self.uiCamera:initOrthographic(display.width,display.height, 1, 1000)  --正交摄像机
    self.uiCamera:setPosition3D{ x = 0, y = 0, z = 500}
    self.uiCamera:setScene(self)

    self.mapCamera:initDefault()
    self.mapCamera:setCameraFlag(cc.CameraFlag.USER2)
    self.mapCamera:setDepth(cc.CameraFlag.USER2)
    self.mapCamera:initPerspective(60 , display.width / display.height, 1, 1000)   --透视摄像机
    self.mapCamera:setPosition3D{ x = 0, y = 0, z = 280}
    self.mapCamera:setScene(self)

    self:addChild(self.uiCamera)
    self:addChild(self.mapCamera)
end

function M:_onInitLayer()
    --------Ex层--------
    self.bottomLayer = cc.Layer:create()
    --------Map层--------
    self.backgroundLayer = cc.Layer:create()

    --------UI层--------
    self.backEffectLayer = cc.Layer:create()
    self.playerLayer = cc.Layer:create()
    self.barrageLayer = cc.Layer:create()
    self.preEffectLayer = cc.Layer:create()
    self.hudLayer = cc.Layer:create()
    self.backUILayer = cc.Layer:create()
    self.mainUILayer = cc.Layer:create()
    self.windowLayer = cc.Layer:create()
    --------Ex层--------
    self.topLayer = cc.Layer:create()


    --初始化摄像机Mask
    self.bottomLayer:setCameraMask(cc.CameraFlag.DEFAULT)

    self.backEffectLayer:setCameraMask(cc.CameraFlag.USER1)
    self.playerLayer:setCameraMask(cc.CameraFlag.USER1)
    self.barrageLayer:setCameraMask(cc.CameraFlag.USER1)
    self.preEffectLayer:setCameraMask(cc.CameraFlag.USER1)
    self.hudLayer:setCameraMask(cc.CameraFlag.USER1)
    self.backUILayer:setCameraMask(cc.CameraFlag.USER1)
    self.mainUILayer:setCameraMask(cc.CameraFlag.USER1)
    self.windowLayer:setCameraMask(cc.CameraFlag.USER1)

    self.backgroundLayer:setCameraMask(cc.CameraFlag.USER2)

    self.topLayer:setCameraMask(cc.CameraFlag.DEFAULT)


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
end

function M:_onInitCallback()
    self:onNodeEvent("enter", function ()
        THSTG.MVCManager.openModule(ModuleType.TEST)
        THSTG.MVCManager.openModule(ModuleType.MAINUI)
        THSTG.MVCManager.openModule(ModuleType.STAGE)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.MVCManager.closeModule(ModuleType.TEST)
        THSTG.MVCManager.closeModule(ModuleType.MAINUI)
        THSTG.MVCManager.closeModule(ModuleType.STAGE)
    end)
end



return M