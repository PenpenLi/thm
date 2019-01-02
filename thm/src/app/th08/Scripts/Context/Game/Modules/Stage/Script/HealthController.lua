local M = class("HealthController",THSTG.ECS.Script)

function M:_onInit()
    self.life = 10

    self._isDead = false
    self._isHurt = false
end
--

function M:hurt(damage)
    self.life = self.life - damage
    self._isHurt = (damage > 0)
    self._isDead = (self.life <= 0)
end


---
function M:_onStart()
    
 
    
end

function M:_onUpdate(delay)



end

function M:_onLateUpdate()
    if self._isHurt then
        self:__onHurt()
        self._isHurt = false
    end

    if self._isDead then
        self:__onDead()
        self:getEntity():destroy()
    end
end

----
function M:__onHurt()
    --闪烁特效
    local animationComp = self:getComponent("AnimationComponent")
    animationComp:play(cc.Blink:create(0.1, 5))

end

function M:__onDead()
    --这里代表击中,而不是对象消亡
    AnimeCache.play({
        layer = self:getEntity():getParent(),
        refNode = self:getEntity(),
        isLoop = false,
        onAction = function (node)
            return {
                cc.Animate:create(AnimationCache.getSheetRes("enemt_breaked")),
                cc.Spawn:create({
                    cc.ScaleBy:create(0.5,2.5),
                    cc.FadeOut:create(0.5)
                }),
            }
        end
    })
end
return M