module("ACTION", package.seeall)

local M = class("M")

function M:ctor(speed,aR,bR,params)
    params = params or {}
    bR = bR or aR
    ----
    self.speed = speed
    self.aR = aR
    self.bR = bR
    self.centerPos = params.centerPos or cc.p(0,0)
    self.isAnticlockwise = params.isAnticlockwise or false
    self.delayTime = params.delayTime or 0
    self.zOrderRang = params.zOrderRang or cc.p(-99,99)
    self.isScale = params.isScale or false

    self._totalTime = 0
end


function M:update(node,delay)
    self._totalTime = self._totalTime + delay * self.speed
    local x = self:_getPositionXAtOval(self._totalTime) --调用之前的坐标计算函数来计算出坐标值
    local y = self:_getPositionYAtOval(self._totalTime)
    node:setPosition(cc.p(x+self.centerPos.x, y+self.centerPos.y))--由于我们画计算出的椭圆你做值是以原点为中心的，所以需要加上我们设定的中心点坐标

    if self.isScale then
        local radio = (math.ceil(y) - y) * 0.1
        node:setScale(1+radio)
    end

    --TODO:y>0的缩放效果
    if (y > 0 ) then
        node:setLocalZOrder(self.zOrderRang.y)
    else
        node:setLocalZOrder(self.zOrderRang.x)
    end
    
end

--x = a * cos(t)  t = [0, 2Pi]
function M:_getPositionXAtOval(t)
    --参数方程
    if(self.isAnticlockwise == false) then
        return self.aR * math.cos((6.2831852 * (1 - t)) + self.delayTime)
    else
        return self.aR * math.cos((6.2831852 * t)+ self.delayTime)
    end
end

--y = b * sin(t)  t = [0, 2Pi]
function M:_getPositionYAtOval(t)
      --参数方程
    if(self.isAnticlockwise == false) then
        return self.bR * math.sin(6.2831852 * (1 - t))
    else
        return self.bR * math.sin(6.2831852 * t)
    end
end



---
function newMoveOvalBy(...)
    local action = M:create(...)
    local delayTime = SCENE.getSettingFPS()
    return cc.Sequence:create({
        cc.DelayTime:create(delayTime),
        cc.CallFunc:create(function(node)
            action:update(node,delayTime)
        end)
    })
end