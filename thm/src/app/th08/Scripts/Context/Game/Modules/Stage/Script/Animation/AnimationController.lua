local M = class("AnimationController",THSTG.ECS.Script)

function M:_onInit()
    self._curAnimation = nil            --当前动作
    self._lastAnimation = nil           --动作
    self._animationDict = false

    self._roleType = nil
end
--
function M:play(roleType,actionType)
    self._curAnimation = actionType
    self._roleType = roleType
end

--
function M:_onLateUpdate()
    self:__onAnimationHandle()
end

----
function M:__onAnimationHandle()
    if self._curAnimation then
        self:__playAnime()
    end
end

--
function M:__playAnime()
    if self._curAnimation == self._lastAnimation then return end
    --TODO:存在逻辑层面的不符
    local spriteComp = self:getComponent("SpriteComponent")
    local sprite = spriteComp:getSprite()

    local actionFunc = StageDefine.ConfigReader.getAction(self._roleType,self._curAnimation)
    actionFunc(sprite,self._lastAnimation)

    self._lastAnimation = self._curAnimation
end
----

return M