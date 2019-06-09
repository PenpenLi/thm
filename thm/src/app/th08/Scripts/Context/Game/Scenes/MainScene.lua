
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
    self.stageCamera = false

    --------Ex层--------
    self.bottomLayer = false        --最底层
    --------Stage层--------
    self.backgroundLayer = false    --背景层
    self.backEffectLayer = false    --后置特效层
    self.playerLayer = false        --主角层
    self.barrageLayer = false       --弹幕层
    self.preEffectLayer = false     --前置特效层
    self.hudLayer = false           --HUD层
    --------UI层--------
    self.backUILayer = false        --UI底层
    self.mainUILayer = false        --UI层
    self.windowLayer = false        --弹窗层
    --------Ex层--------
    self.topLayer = false           --最顶层

    -- self:_onInitCamera()         -TODO:有BUG
    self:_onInitLayer()
    self:_onInitCallback()
end

function M:_onInitCamera()
    --两台摄像机
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    self.uiCamera = cc.Camera:create()
    self.stageCamera = cc.Camera:create() 

    self.uiCamera:initDefault()
    self.uiCamera:setCameraMask(cc.CameraFlag.USER1)
    self.uiCamera:setDepth(cc.CameraFlag.USER1)
    -- self.uiCamera:initOrthographic(100, 100, 10, 200)  --正交摄像机
    -- self.uiCamera:setPosition3D{ x = 0, y = 0, z = 500}
    self.uiCamera:setScene(self)


    self.stageCamera:initDefault()
    self.stageCamera:setScene(self)
    self.stageCamera:setCameraMask(cc.CameraFlag.USER2)
    self.stageCamera:setDepth(cc.CameraFlag.USER2)
    self.stageCamera:initPerspective(46.5 / display.width * display.height, display.width / display.height, 10, 4000)   --透视摄像机
	self.stageCamera:setPosition3D{ x = 0, y = 0, z = 500}

    self:addChild(self.uiCamera)
    self:addChild(self.stageCamera)
end

function M:_onInitLayer()
    --------Ex层--------
    self.bottomLayer = cc.Layer:create()
    --------Stage层--------
    self.backgroundLayer = cc.Layer:create()
    self.backEffectLayer = cc.Layer:create()
    self.playerLayer = cc.Layer:create()
    self.barrageLayer = cc.Layer:create()
    self.preEffectLayer = cc.Layer:create()
    self.hudLayer = cc.Layer:create()
    --------UI层--------
    self.backUILayer = cc.Layer:create()
    self.mainUILayer = cc.Layer:create()
    self.windowLayer = cc.Layer:create()
    --------Ex层--------
    self.topLayer = cc.Layer:create()


    --初始化摄像机Mask
    self.bottomLayer:setCameraMask(cc.CameraFlag.DEFAULT)

    self.backgroundLayer:setCameraMask(cc.CameraFlag.USER2)
    self.backEffectLayer:setCameraMask(cc.CameraFlag.USER2)
    self.playerLayer:setCameraMask(cc.CameraFlag.USER2)
    self.barrageLayer:setCameraMask(cc.CameraFlag.USER2)
    self.preEffectLayer:setCameraMask(cc.CameraFlag.USER2)
    self.hudLayer:setCameraMask(cc.CameraFlag.USER2)

    self.backUILayer:setCameraMask(cc.CameraFlag.USER1)
    self.mainUILayer:setCameraMask(cc.CameraFlag.USER1)
    self.windowLayer:setCameraMask(cc.CameraFlag.USER1)

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