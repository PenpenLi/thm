local DBXAtlas = "thstg.Framework.Component.Animation.DBX.DBXAtlas"
local DBXSkeleton = "thstg.Framework.Component.Animation.DBX.DBXSkeleton"
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
---


return M

