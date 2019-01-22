module(..., package.seeall)

local M = class("BossPrefab",StageDefine.BossEntity)

function M:ctor()
    M.super.ctor(self)

    ----
    self.healthBar = THSTG.UI.newRadialProgressBar({
        x = 0,
        y = 0, --半径
        anchorPoint = THSTG.UI.POINT_CENTER,
        isReverse = true,
        minValue = 0,
        maxValue = 50,
        offset = 90,
        style = {
            --背景皮肤
            bgSkin = false,
            --进度条皮肤
            progressSkin = {
                src = ResManager.getUIRes(UIType.PROGRESS_BAR, "prog_radial_boss_hp"),
            }
        }
    })
    self.healthBar:setName("HEALTH_BAR")
    self.healthBar:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
    self:addChild(self.healthBar)

    self.animationController = StageDefine.BossAnimation.new()
    self:addScript(self.animationController)

    self.helthController = StageDefine.BossHealth.new()
    self:addScript(self.helthController)

    self.bossController = StageDefine.BossController.new()
    self:addScript(self.bossController)
end

----------


return M