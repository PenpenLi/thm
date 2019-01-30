local M = class("WipeController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.wipeRadius = 5                             --消弹半径
    self.wipeMaxTime = 3                           --wipe的剩余时间
    self.wipeRestTime = self.wipeMaxTime            --wipe的剩余时间
    self.wipeRecoveryFactor = 0.5                   --wipe恢复系数
    self.bossProtectRadius = 60                      --Boss保护半径(这个范围消弹无效)

    self.__effectNode = THSTG.UI.newParticleSystem({
        x = 0,
        y = 0,
        anchorPoint = cc.p(0.5,0.5),
        isLoop = true,
        src = ResManager.getResMul(ResType.SFX,SFXType.PARTICLE,"ccp_gk_protected"),
    })
    self.__effectNode:setCascadeOpacityEnabled(false)
    self.__effectNode:setScale(0.6)
    self.__effectNode:setLife(0.8)
    self.__isStateWipe = nil
    self.__transComp = nil
end

-------
-------
function M:wipe(state)
    if state == self.__isStateWipe then return end
    if state then self:_wipeOpen() else self:_wipeClose() end
end
function M:isWipe()
    return self.__isStateWipe or false
end

function M:_wipeOpen()
    -- local myHealth = self:getScript("HealthController")
    -- if not myHealth:isInvincible() then
        print(15,"wipe开")
        --开始计时
        if self.wipeRestTime > 0 then
            self:_onWipeOpen()
            self.__isStateWipe = true
        end
    -- end
end

function M:_wipeClose()
    print(15,"wipe关")
    self:_onWipeClose()
    self.__isStateWipe = false
end

--护罩破碎(受击过大导致),短时间内受到100发子弹打击,或者时间到了
function M:_wipeBreaked()
    --音效
    --TODO:晃屏
    --爆裂特效
    GlobalUtil.playParticle({
        refNode = self:getEntity(),
        src = ResManager.getResMul(ResType.SFX,SFXType.PARTICLE,"ccp_gk_star03"),
        scale = 1.5
     })
    self:_wipeClose()
end
function M:_onWipeInvalid()
    --音效

    self:_wipeClose()
end
function M:_onWipeTimeout()
    GlobalUtil.playParticle({
        refNode = self:getEntity(),
        src = ResManager.getResMul(ResType.SFX,SFXType.PARTICLE,"ccp_gk_star03"),
        scale = 1.5
     })
    --音效
    self:_wipeClose()
end
function M:_onWipeOpen()
    self.__effectNode:play()
end
function M:_onWipeClose()
    self.__effectNode:stop()
end
--
function M:_onAdded(entity)
    self.__effectNode:addTo(entity)
    self.__effectNode:setPosition(cc.p(entity:getContentSize().width/2,entity:getContentSize().height/2))

end

function M:_onStart()
    self.__transComp = self:getComponent("TransformComponent")
end

function M:_onUpdate(delay)
    if self:isWipe() then
        --是否超时
        if self.wipeRestTime > 0 then
            local isCanWipe = true
            -- 消弹模式下不允许接近Boss的范围,半径
            local bossEntitys = THSTG.ECSManager.findEntitiesByName("BOSS")
            if next(bossEntitys) then
                local bossEntity = bossEntitys[1]
                local bossTransComp = bossEntity:getComponent("TransformComponent")
                local myTransComp = self.__transComp
                local bossPos = cc.p(bossTransComp:getPosition())
                local myPos = cc.p(myTransComp:getPosition())

                local distance = cc.pGetDistance(bossPos, myPos)
                isCanWipe = (distance > self.bossProtectRadius)
            end
            if isCanWipe then
                --TODO:查找范围内的敌弹并消除
            else
                self:_onWipeInvalid()
            end
        end

        self.wipeRestTime = self.wipeRestTime - delay
        if self.wipeRestTime <= 0 then
            self.wipeRestTime = 0
            self:_onWipeTimeout()
            print(15,"wipe能量耗尽")
        end
    else
        --自动回复能量
        local addTime = self.wipeRecoveryFactor * delay
        self.wipeRestTime = math.min(self.wipeMaxTime, self.wipeRestTime + addTime)
    end
end


return M