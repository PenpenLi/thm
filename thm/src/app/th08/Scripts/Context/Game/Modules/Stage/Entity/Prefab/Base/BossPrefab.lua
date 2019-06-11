module(..., package.seeall)

local M = class("BossPrefab",StageDefine.BossEntity)

function M:ctor()
    M.super.ctor(self)
    self:setName("BOSS")

    self.animationController = false
    self.spellController = false
    self.helthController = false
    self.bossController = false

    self.hud = false
    self.body = false

    self:_initNode()
    self:_initScprit()

end
----------
function M:_initScprit()
    self.animationController = StageDefine.BossAnimation.new()
    self:addScript(self.animationController)

    self.collisionController = StageDefine.BossCollision.new()
    self:addScript(self.collisionController)
    
    self.helthController = StageDefine.BossHealth.new()
    self:addScript(self.helthController)

    self.bossController = StageDefine.BossController.new()
    self:addScript(self.bossController)

    self.spellController = StageDefine.EnemySpellController.new()
    self:addScript(self.spellController)
end

function M:_initNode()
    --[[
        Node
         hud
          ui*...
         body
          sprite
          ui*...
    ]]
    --BOSS血条
    self.hud = StageDefine.BaseEntity.new()
    self.hud:setName("HUD")
    self:addChild(self.hud)
    
    self.hud.uiPrgBar = THSTG.UI.newRadialProgressBar({
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
    self.hud:addChild(self.hud.uiPrgBar)

    --
    self.body = StageDefine.BaseEntity.new()
    self.body:setName("BODY")
    self:addChild(self.body)

    self.body.sprite = StageDefine.BaseEntity.new()
    self.body.sprite:addComponent(StageDefine.SpriteComponent.new())
    self.body.sprite:addComponent(StageDefine.AnimationComponent.new())
    self.body.sprite:setName("SPRITE")
    self:addChild(self.body.sprite)

    self.body.uiMagicCircle = THSTG.UI.newSprite({
        x = self:getContentSize().width/2,
        y = self:getContentSize().height/2, --半径
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = SpriteServer.createFrame("etama2","etama2_51"),
        scale = 1.5,
    })
    self.body.uiMagicCircle:runAction(cc.RepeatForever:create(cc.Sequence:create({
        cc.Spawn:create({
            cc.RotateBy:create(5.0, 360),
            cc.ScaleTo:create(3.0,2),
        }),
        cc.Spawn:create({
            cc.RotateBy:create(5.0, 360),
            cc.ScaleTo:create(3.0,1.5),
        }),
    })))

    self.body:addChild(self.body.uiMagicCircle,-1)    --至于底层

end

return M