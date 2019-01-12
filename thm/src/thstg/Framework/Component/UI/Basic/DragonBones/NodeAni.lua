-- 基于dragonbones开源骨骼框架
-- 建议嵌套子动画不要超过2级

local NodeAni = class("NodeAni", function(...)
    return cc.Node:create()
end)

--- 构造方法
-- @string fileName 文件名
-- @string armatureName 骨架名
function NodeAni:ctor(fileName, armatureName)
    self.__fileName = fileName
    local factory = db.DBCCFactory:getInstance()
    self.__factory = factory

    local skeletonName = Animation.getSkeletonXml(fileName)
    local textureName = Animation.getTextureXml(fileName)

    factory:loadDragonBonesData(skeletonName, fileName)
    factory:loadTextureAtlas(textureName, fileName)

    if (armatureName) then
        self:setArmatureName(armatureName)
    end
end

--- 播放指定动作的动画
-- @string actionName 动作名 默认值为"a"
-- @treturn self
function NodeAni:play(actionName)
    assert(self.__armature, "@NodeAni play error! must setArmatureName first!!")
    self.__actionName = actionName or "a"
    self.__armature:getAnimation():gotoAndPlay(self.__actionName)
    return self
end

--- 停止动画并恢复到初始状态
-- @treturn self
function NodeAni:stop()
    assert(self.__armature, "@NodeAni play error! must setArmatureName first!!")
    if self.__actionName then
        self.__armature:getAnimation():gotoAndStop(self.__actionName, 0, 0)
    end
    return self
end

--- 设置动画结束时执行回调方法
-- 循环动画不会触发回调
-- @func func 结束时回调方法
-- @treturn self
function NodeAni:setEnded(func)
    self.__endedFunc = func
    self:_registerAnimationEvent()
    return self
end

--- 移除动画结束时的回调方法
-- @treturn self
function NodeAni:removeEnded()
    self.__endedFunc = nil
    return self
end

--- 设置循环动画时每一次结束时的回调方法
-- 非循环动画不会触发回调， 循环动画回调会触发多次
-- @func func 每一次结束时回调方法
-- @treturn self
function NodeAni:setLoopEnded(func)
    self.__loopEndedFunc = func
    self:_registerAnimationEvent()
    return self
end

--- 移除循环动画每一次结束时的回调方法
-- @treturn self
function NodeAni:removeLoopEnded()
    self.__loopEndedFunc = nil
    return self
end

--- 设置骨架
-- @string armatureName 骨架名字
-- @treturn self
function NodeAni:setArmatureName(armatureName)
    if (self.__armature) then
        self.__armature:removeFromParent()
        self.__armature = nil
    end
    self.__armatureName = armatureName
    local armature = self.__factory:buildArmatureNode(armatureName):addTo(self)
    self.__armature = armature
    return self
end

--- 设置骨骼所在的节点为新的node
-- @string boneName 骨骼名字
-- @tparam cc.Node node 新的node
-- @treturn self
function NodeAni:setBoneNode(boneName, node)
    assert(self.__armature and boneName and node, "@NodeAni setBoneNode error!")
    local slot = self.__armature:getCCSlot(boneName)
    local oldDisplay = slot:getCCDisplay()
    local anchorPoint
    if (oldDisplay) then
        anchorPoint = oldDisplay:getAnchorPoint()
    else
        anchorPoint = cc.p(0.5, 0.5)
    end
    node:setAnchorPoint(anchorPoint)
    node:retain()
    slot:setDisplayImage(node)
    return self
end

--- 设置子骨骼所在的节点为新的node
-- @string parentBoneName 子动画所在的父骨骼名
-- @string childBoneName 子动画的子骨骼名
-- @tparam cc.Node node 新的node
-- @treturn self
function NodeAni:setChildBoneNode(parentBoneName, childBoneName, node)
    assert(self.__armature and parentBoneName and childBoneName and node, "@NodeAni setChildBoneNode error!")
    local slot = self.__armature:getCCSlot(parentBoneName)
    local armature = slot:getCCChildArmature()
    assert(armature, "@NodeAni getChildArmature error")
    local childSlot = armature:getCCSlot(childBoneName)
    local oldDisplay = childSlot:getCCDisplay()
    local anchorPoint
    if (oldDisplay) then
        anchorPoint = oldDisplay:getAnchorPoint()
    else
        anchorPoint = cc.p(0.5, 0.5)
    end
    node:setAnchorPoint(anchorPoint)
    node:retain()
    childSlot:setDisplayImage(node)
    return self
end

function NodeAni:_registerAnimationEvent()
    assert(self.__armature, "@NodeAni addEventListener error! must setArmatureName first!!")
    if not self.__armature._isRegisterAnimation then
        self.__armature._isRegisterAnimation = true
        self.__armature:registerAnimationEventHandler(function(event)
            if event.type == Animation.COMPLETE and self.__endedFunc then
                self.__endedFunc(event)
            elseif event.type == Animation.LOOP_COMPLETE and self.__loopEndedFunc then
                self.__loopEndedFunc(event)
            end
        end)
    end
    return self
end

return NodeAni