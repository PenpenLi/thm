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
    self._animaSize = false

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

function M:getSize()
    return self._animaSize or cc.size(0,0)
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
function M:_onAwake()
    self._baseData = self:getScript("EntityBasedata")
    self.animaComp = self:getComponent("AnimationComponent")
    self.spriteComp = self:getComponent("SpriteComponent")

    self._transComp = self:getComponent("TransformComponent")

end

function M:_onStart()
    
    self._prevPos = cc.p(self._transComp:getPositionX(),self._transComp:getPositionY())
    self._animaSize = false
    
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
    local code = self._baseData:getEntityCode()
    local animCfg = self._baseData:getData():getAnimationData()
    --动画装配器,通过配置装配动画
    self.animaComp:removeAllAnimations()
    if animCfg then
        if animCfg.atlas ~= "" then
            if animCfg.skeName ~= "" then
                local atlasArray = string.split(animCfg.atlas ,";")
                local skeNameArray = string.split(animCfg.skeName ,";")
                local atals = false
                local skeName = false
                local count = (#atlasArray > #skeNameArray) and #atlasArray or #skeNameArray
                for i = 1, count do
                    atals = atlasArray[i] or atals
                    skeName = skeNameArray[i] or skeName

                    --XXX:这里可以预加载
                    AnimationServer.loadDBXFile(
                        ResManager.getRes(ResType.TEXTURE,TexType.SHEET,atals),
                        ResManager.getRes(ResType.ANIMATION,AnimaType.SEQUENCE,skeName)
                    )
                    
                    local skeleton = AnimationServer.getSkeleton(skeName)
                    for _,v in ipairs(skeleton:getAnimationNameList()) do 
                        local animation = AnimationServer.createAnimation(skeName,v)
                        self.animaComp:addAnimation(v,animation)
                        if not self._animaSize then
                           self:_setupAnimationSize(animation)
                        end
                    end
                end
            elseif animCfg.frameName ~= "" then
                local frameName = string.format(animCfg.frameName, code)
                SpriteServer.loadDBXFile(
                    ResManager.getRes(ResType.TEXTURE,TexType.SHEET,animCfg.atlas)
                )
                --是一帧,需要转为帧动画
                local frame = SpriteServer.createFrame(animCfg.atlas,frameName)
                if frame then
                    local animation = display.newAnimation({frame},1/12)
                    self.animaComp:addAnimation(AnimaState.DEFAULT,animation)
                    -- self.spriteComp:setSpriteFrame(frame)
                    if not self._animaSize then
                        self:_setupAnimationSize(animation)
                    end
                end
            end
            --精灵修正
            self.spriteComp:setAnchorPoint(animCfg.anchorPoint or cc.p(0.5,0.5))
            self.spriteComp:setRotation(animCfg.rotation or 0)
            self.spriteComp:setScaleX(animCfg.scale.x or 1)
            self.spriteComp:setScaleY(animCfg.scale.y or 1)
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
function M:_setupAnimationSize(animation)
    local frames = animation:getFrames() 
    local firstFrame = frames[1] and frames[1]:getSpriteFrame()
    if firstFrame then
        self._animaSize = firstFrame:getOriginalSize()
    end
end

return M