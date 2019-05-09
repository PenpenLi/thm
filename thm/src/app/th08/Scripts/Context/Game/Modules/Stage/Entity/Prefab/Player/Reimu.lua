module(..., package.seeall)

local M = class("Reimu",StageDefine.PlayerPrefab)
function M:ctor()
    M.super.ctor(self)
    
    --添加两个僚机的实体
    self.gyoku1 = StageDefine.OnmyouGyoku.new()
    self.gyoku1:setName("GYOKU1")
    self:addChild(self.gyoku1)

    self.gyoku2 = StageDefine.OnmyouGyoku.new()
    self.gyoku2:setName("GYOKU2")
    self:addChild(self.gyoku2)

    --普通子弹的发射口
    self.emitter = StageDefine.EmitterPrefab.new()
    self.emitterMainCtrl = self.emitter:getScript("EmitterController")
    self:addChild(self.emitter)

    ----
    self.wipeController = StageDefine.ReimuWipeController.new()
    self:addScript(self.wipeController)

    self.slowController = StageDefine.ReimuSlowController.new()
    self:addScript(self.slowController)

    self.playerController = StageDefine.ReimuController.new()
    self.playerController.roleType = GameDef.Stage.ERoleType.Reimu
    self:addScript(self.playerController)

    ----
    self.emitterMainCtrl.objectPrefab = StageDefine.ReimuBullet
    self.entityData:setDataByCode(10100001)
    self.spriteNode.entityData:setData(self.entityData:getData()) --共用一份数据
    

end

return M