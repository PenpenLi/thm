local DBXAtlas = require "thstg.Framework.Component.Animation.DragonBonesX.DBXAtlas"
local DBXSkeleton = require "thstg.Framework.Component.Animation.DragonBonesX.DBXSkeleton"
local M = class("DBXAnimater")

function M:ctor(texPath,skePath)
    self._atlas = false
    self._skeleton = false

    self:load(path)
end

function M:load(texPath,skePath)
    self:setAtlas(DBXAtlas.new(texPath))
    self:setSkeleton(DBXSkeleton.new(skePath))
end
---
function M:getAtlas()
    return self._atlas
end

function M:getSkeleton()
    return self._skeleton
end

function M:setAtlas(atlas)
    self._atlas = atlas
end

function M:setSkeleton(skeleton)
    self._skeleton = skeleton
end
---
function M:createAnimation(name)
    return self._skeleton:createAnimation(self._atlas,name)
end

function M:createAnimate(name)
    local animation = self:createAnimation(name)
    if animation then
        return cc.Animate:create(animation)
    end
    return false
end

function M:createAnime(name)
    local skeleton = self:getSkeleton()
    local animate = createAnimate(name)
    local times =  skeleton:getAnimationTimes()
    if time > 0 then
        local seq = {}
        for i = 1,time do
            table.insert( seq,animate )
        end
        return cc.Sequence:create(seq)
    elseif time == 0 then
        return cc.RepeatForever:create(animate)
    end
end
---


return M

