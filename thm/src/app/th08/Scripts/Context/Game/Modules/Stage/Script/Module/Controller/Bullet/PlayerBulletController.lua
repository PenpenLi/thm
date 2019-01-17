local M = class("PlayerBulletController",StageDefine.BulletController)

function M:_onInit()
    M.super._onInit(self)

    self.rotation = -90
    self.speed = cc.p(0,20)
    self.centerPoint = cc.p(0.875,0.5)

    
end
---
function M:reset(refEntity)
    --重置位置
    local refTransComp = refEntity:getComponent("TransformComponent")
    local myPosComp = self:getComponent("TransformComponent")
    myPosComp:setPositionX(refTransComp:getPositionX() + 0)
    myPosComp:setPositionY(refTransComp:getPositionY() - 25)  --贴图尾巴太长了
    -- myPosComp:getEntity():setAnchorPoint(cc.p(0.5,0.5))

    --重置生命值
    local myHealthComp = self:getScript("PlayerBulletHealth")
    myHealthComp:setBlood(100)

    --
    local rigidbodyComp = self:getComponent("RigidbodyComponent")
    rigidbodyComp:setSpeed(self.speed.x,self.speed.y)

    --
    local animationComp = self:getComponent("AnimationComponent")
    animationComp:getSprite():setOpacity(255)
    animationComp:getSprite():setScale(1)
    animationComp:getSprite():setRotation(-90)
end
---
function M:_onAdded(entity)
    M.super._onAdded(self,entity)
 
    entity:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
    entity:setActive(false)
end
---
function M:_onActive(val)
    -- local animationComp = self:getComponent("AnimationComponent")
    -- animationComp:getSprite():setVisible(val)
end

function M:_onStart()
    M.super._onStart(self)


end

---
function M:_onUpdate(delay)

end

function M:_onLateUpdate()

end

return M