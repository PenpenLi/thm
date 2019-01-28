
local M = class("WingmanBulletHealth",StageDefine.BulletHealth)

function M:_onInit()
   M.super._onInit(self)

end
--

----
function M:_onHurt()


end

function M:_onDead()
    --TODO:这个动画应该保存下来,以被复用是使用,太过频繁会掉帧
    local actionComp = self:getComponent("ActionComponent")
    actionComp:runAction(cc.Sequence:create({
        --自己旋转,缩小,消失
        cc.Spawn:create({
            --旋转不是绕中心点
            cc.RotateBy:create(1,280),
            cc.ScaleBy:create(1,0.6),
            cc.FadeOut:create(1)
        }),
        cc.CallFunc:create(function()
            if ObjectCache.release(self:getEntity()) then self:getEntity():setActive(false) else self:killEntity() end
        end)
    }))
    SoundManager.playEffect(200103)
end



return M