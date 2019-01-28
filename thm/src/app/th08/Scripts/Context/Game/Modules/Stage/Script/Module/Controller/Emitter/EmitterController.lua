local M = class("EmitterController",THSTG.ECS.Script)

function M:_onInit()
    self.shotInterval = 0.10          --时间间隔
    self.shotSpeed = cc.p(0,10)       --子弹的初始速度
    self.objectPrefab = nil           --发射的预制体
    self.shotOffset = cc.p(0,0)       --子弹发射偏移
    self.prefabNum = 10               --预制数量

    self._nextShotTime = 0
end

function M:shot()
    if THSTG.TimeUtil.time() >= (self._nextShotTime or 0) then
        if not self.objectPrefab then return end

        local bullet = ObjectCache.create(self.objectPrefab)
        local myTransComp = self:getComponent("TransformComponent")
        local bulletTransComp = bullet:getComponent("TransformComponent")

        local myAbsPos = myTransComp:convertToWorldSpace()--由于图层的关系,需采用绝对坐标
        bulletTransComp:setPositionX(myAbsPos.x + self.shotOffset.x)
        bulletTransComp:setPositionY(myAbsPos.y + self.shotOffset.y)

        local rigidbodyComp = bullet:getComponent("RigidbodyComponent")
        rigidbodyComp:setSpeed(self.shotSpeed.x,self.shotSpeed.y)

        local bulletControlScript = bullet:getScript("BulletController")
        bulletControlScript:reset()
        bullet:setActive(true)

        self._nextShotTime = THSTG.TimeUtil.time() + self.shotInterval
    end
end


function M:_onStart()
    M.super._onStart(self)
    ObjectCache.expand(self.objectPrefab,self.prefabNum)
end

return M