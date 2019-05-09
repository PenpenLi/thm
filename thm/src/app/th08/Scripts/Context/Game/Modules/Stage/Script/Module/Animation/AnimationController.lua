--[[------------------
主要调节动画的状态,相当于动画状态机
]]----------------------
local M = class("AnimationController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self._fsm = THSTG.UTIL.newStateMachine() --状态机
    self.animaComp = nil
    self.spriteComp = nil
    self._baseData = nil

    self._transComp = nil
    self._prevPos = cc.p(0,0)

end
--
function M:play(actionType)
    if self._fsm:cannotDoEvent(actionType) then return end

    self._fsm:doEvent(actionType)
end

function M:getSprite()
    return self.animaComp:_getSprite()
end
----
function M:_onLateUpdate()
    local posPoint = self._transComp:getWorldPosition()
    
    self:_onAction({
        dx = posPoint.x - self._prevPos.x,
        dy = posPoint.y - self._prevPos.y,
    })

    self._prevPos = self._transComp:getWorldPosition()
end

------------------
function M:_onStart()
    self._baseData = self:getScript("EntityBasedata")

    self.animaComp = self:getComponent("AnimationComponent")
    self.spriteComp = self:getComponent("SpriteComponent")

    self._transComp = self:getComponent("TransformComponent")
    self._prevPos = cc.p(self._transComp:getPositionX(),self._transComp:getPositionY())

    self:_onSetup()
    
    local cfg = self:_onState()
    if cfg and next(cfg) then
        self._fsm:setupState(cfg)
    end
end
------------------
--[[以下由子类重载]]
function M:_onSetup()
   --加载动画配置
    local entityCode = self._baseData:getEntityCode()
    local animCfg = AnimationConfig.getAllInfo(entityCode)
    --动画装配器,通过配置装配动画
    self.animaComp:removeAllAnimations()
    if animCfg then
        if animCfg.atlas ~= "" then
            if animCfg.skeName ~= "" then
                --XXX:这里可以预加载
                THSTG.ANIMATION.DBXManager.loadDBXFile(
                    ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,animCfg.atlas),
                    ResManager.getResSub(ResType.ANIMATION,AnimType.SEQUENCE,animCfg.skeName)
                )
                
                local skeleton = THSTG.ANIMATION.DBXManager.getSkeleton(animCfg.skeName)
                for _,v in ipairs(skeleton:getAnimationNameList()) do 
                    local animation = THSTG.ANIMATION.DBXManager.createAnimation(animCfg.skeName,v)
                    self.animaComp:addAnimation(v,animation)
                end
            elseif animCfg.frameName ~= "" then
                THSTG.ANIMATION.DBXManager.loadDBXFile(
                    ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,animCfg.atlas)
                )
                --是一帧,需要转为帧动画
                local frame = THSTG.ANIMATION.DBXManager.createFrame(animCfg.atlas,animCfg.frameName)
                if frame then
                    self.animaComp:addAnimation(AnimStatus.DEFAULT,display.newAnimation({frame},1/12))
                end
            end
            --精灵修正
            self.spriteComp:setAnchorPoint(animCfg.anchorPoint)
            self.spriteComp:setRotation(animCfg.rotation)
            self.spriteComp:setScaleX(animCfg.scale.x)
            self.spriteComp:setScaleY(animCfg.scale.y)
        end  
    end
end

function M:_onState()

end

--cc.Move无法主动调用,这里由自身进行判断
function M:_onMove(dx,dy)

end

function M:_onAction(params)
    self:_onMove(params.dx,params.dy)
end
--

return M