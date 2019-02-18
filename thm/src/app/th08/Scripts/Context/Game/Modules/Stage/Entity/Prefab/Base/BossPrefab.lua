module(..., package.seeall)

local M = class("BossPrefab",StageDefine.BossEntity)

function M:ctor()
    M.super.ctor(self)

    ----
    self:setName("BOSS")
    --BOSS血条
    self.healthBar = THSTG.UI.newRadialProgressBar({
        x = self:getContentSize().width/2,
        y = self:getContentSize().height/2, --半径
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
    self:addChild(self.healthBar)


    
    self.spellController = StageDefine.EnemySpellController.new()
    self:addScript(self.spellController)
    
    self.helthController = StageDefine.BossHealth.new()
    self:addScript(self.helthController)
    ---


end

----------


return M