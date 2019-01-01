local M = class("BatmanController",THSTG.ECS.Script)

function M:_onInit()

end

function M:_onStart()
    local animationComp = self:getComponent("AnimationComponent")
    animationComp:play(cc.RepeatForever:create(
        cc.Animate:create(AnimationCache.getSheetRes("enemy_01_a_normal"))
    ))
 
    
end

function M:_onUpdate()

end

--播放销毁动画
function M:_onEnd()
    --TODO:不应该在这里添加动画,这里代表对象消亡,而不是击中
    AnimeCache.play({
        layer = self:getEntity():getParent(),
        refNode = self:getEntity(),
        onAction = function (node)
            return cc.Sequence:create({
                cc.Animate:create(AnimationCache.getSheetRes("enemt_breaked")),
                cc.Spawn:create({
                    cc.ScaleBy:create(0.5,2.5),
                    cc.FadeOut:create(0.5)
                }),
                cc.CallFunc:create(function()
                    node:removeFromParent()
                end),
            })
        end
    })
end

return M