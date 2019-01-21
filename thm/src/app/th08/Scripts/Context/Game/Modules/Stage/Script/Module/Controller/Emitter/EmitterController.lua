local M = class("EmitterController",THSTG.ECS.Script)

function M:_onInit()
    self.shotInterval = 0.10          --时间间隔
    self.bulletPrefab = nil           --发射的预制体
    self.shotOffset = cc.p(0,0)       --子弹发射偏移

    self._nextShotTime = 0
end

function M:shot()
    if THSTG.TimeUtil.time() >= (self._nextShotTime or 0) then
        if not self.bulletPrefab then return end

        local bullet = ObjectCache.create(self.bulletPrefab)
        local myTransComp = self:getComponent("TransformComponent")
        local bulletTransComp = bullet:getComponent("TransformComponent")

        local myAbsPos = myTransComp:convertToWorldSpace()--由于图层的关系,需采用绝对坐标
        bulletTransComp:setPositionX(myAbsPos.x + self.shotOffset.x)
        bulletTransComp:setPositionY(myAbsPos.y + self.shotOffset.y)

        local bulletControlScript = bullet:getScript("BulletController")
        bulletControlScript:reset(self:getEntity())
        bullet:setActive(true)

        self._nextShotTime = THSTG.TimeUtil.time() + self.shotInterval
    end
end


return M