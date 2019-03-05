module(..., package.seeall)

local M = class("HealthBar",StageDefine.BaseEntity)

function M:ctor()
    M.super.ctor(self)

    --BOSS血条
    self.uiPrgBar = THSTG.UI.newRadialProgressBar({
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
    self:addChild(self.uiPrgBar)

    ----


end

----------


return M