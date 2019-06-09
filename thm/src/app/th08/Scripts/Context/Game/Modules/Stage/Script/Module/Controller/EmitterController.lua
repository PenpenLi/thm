local M = class("EmitterController",THSTG.ECS.Script)

function M:_onInit()
    self.shotInterval = 0.10          --时间间隔
    self.shotSpeed = cc.p(0,10)       --子弹的初始速度
    self.bulletCode = false           --子弹code
    self.shotOffset = cc.p(0,0)       --子弹发射偏移
    self.prefabNum = 10               --预制数量

    self._nextShotTime = 0
    self._objectPrefab = nil           --发射的预制体
end

function M:shot()
    if THSTG.TimeUtil.time() >= (self._nextShotTime or 0) then
        if not self.bulletCode then return end

        local bullet = StageDefine.StageEntityManager.createEntity(self.bulletCode,true)
        local myTransComp = self:getComponent("TransformComponent")
        local bulletTransComp = bullet:getComponent("TransformComponent")

        local myAbsPos = myTransComp:getWorldPosition()--由于图层的关系,需采用绝对坐标
        bulletTransComp:setPositionX(myAbsPos.x + self.shotOffset.x)
        bulletTransComp:setPositionY(myAbsPos.y + self.shotOffset.y)

        local rigidbodyComp = bullet:getComponent("RigidbodyComponent")
        rigidbodyComp:setSpeed(self.shotSpeed.x,self.shotSpeed.y)

        local bulletControlScript = bullet:getScript("BulletController")
        bulletControlScript:reset()

        Dispatcher.dispatchEvent(EventType.STAGE_ADD_ENTITY,bullet)

        self._nextShotTime = THSTG.TimeUtil.time() + self.shotInterval
    end
end


function M:_onStart()
    M.super._onStart(self)

    -- local bulletCode = self:getEntity():getParent():getScript("EntityBasedata"):getData():getConfigData().bulletCode --TODO:
    if self.bulletCode then
        StageDefine.StageEntityManager.expandEntity(self.bulletCode,self.prefabNum)

        local bulletTemp = StageDefine.StageEntityManager.createEntity(self.bulletCode)--随便拿一个出来赋值
        if bulletTemp then
            local bulletBasedata = bulletTemp:getScript("EntityBasedata"):getData()
            self.shotInterval = bulletBasedata:getConfigData().freq or self.shotInterval
            self.shotSpeed = cc.p(0,bulletBasedata:getConfigData().speed or self.shotSpeed.y)

        end
    end
end

return M