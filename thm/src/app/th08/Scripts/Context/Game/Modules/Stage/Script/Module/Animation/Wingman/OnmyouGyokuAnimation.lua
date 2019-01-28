local M = class("OnmyouGyokuAnimation",StageDefine.WingmanAnimation)

function M:_onInit()
    M.super._onInit(self)
end
function M:_onStart()
    M.super._onStart(self)
end

function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "Idle", from = {},  to = "Idle"},
        },
        callbacks = {
            onIdle = handler(self,self._onIdle),
        },
    }
end

function M:_onIdle(event)
    self:getSprite():runAction(cc.Sequence:create({
        cc.Animate:create(AnimationCache.getResBySheet("enemy","onmyou_gyoku_r")),
        cc.CallFunc:create(function() 
            self:getSprite():runAction(cc.RepeatForever:create(
                cc.RotateBy:create(1,360)   --阴阳玉自旋
            ))
        end)
    }))
    self:getSprite():setScale(0.5)  --缩小到原来的0.5
end

----


return M