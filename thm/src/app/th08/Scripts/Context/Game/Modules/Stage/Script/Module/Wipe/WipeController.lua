local M = class("WipeController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.wipeRadius = 5                             --消弹半径
    self.wipeMaxTime = 10                           --wipe的剩余时间
    self.wipeRestTime = self.wipeMaxTime            --wipe的剩余时间
    self.bossProtectRadius = 0                      --Boss保护半径(这个范围消弹无效)

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
end

-------
-------
function M:wipe(state)
    local function wipeOpen()
        --XXX:受闪烁影响,无敌时间无法开启消弹
        local myHealth = self:getScript("HealthController")
        if not myHealth:isInvincible() then
            print(15,"wipe开")
            self.__effectNode:play()
        end
    end
    local function wipeClose()
        print(15,"wipe关")
        self.__effectNode:stop()
    end
    if state then wipeOpen() else wipeClose() end
    self.__isStateWipe = state
end

--护罩破碎(受击过大导致),短时间内受到100发子弹打击,或者时间到了
function M:wipeBreak()

end

function M:isWipe()
    return self.__isStateWipe or false
end
--
function M:_onAdded(entity)
    self.__effectNode:addTo(entity)
    self.__effectNode:setPosition(cc.p(entity:getContentSize().width/2,entity:getContentSize().height/2))

end

function M:_onStart()

end

function M:_onUpdate()
    --TODO:消弹模式下不允许接近Boss的范围,半径
    

end


function M:_onLateUpdate()

end

return M