local DBXUtil = require "thstg.Framework.Component.Animation.DragonBonesX.DBXUtil"
local M = class("DBXSkeleton")

function M:ctor(path)
    self._oriInfo = false

    self:load(path)
end

function M:load(path)
    local jsonStr = DBXUtil.loadJsonFile(path)
    self._oriInfo = DBXUtil.parseSkeletonMap(jsonStr)
    
end
----
function M:getSkeletonName()
    if self._oriInfo then
        return self._oriInfo.name
    end
    return ""
end
function M:getAnimationInfos(name)
    if self._oriInfo then 
        return self._oriInfo.armature and self._oriInfo.armature[name]
    end
    return nil
end

function M:getAnimationRate(name)
    local info = self:getAnimationInfos(name)
    if info then
        return info.frameRate
    end
    return false
end

function M:getAnimationTimes(name)
    local info = self:getAnimationInfos(name)
    if info then
        return info.animation[1].playTimes
    end
    return 0
end

function M:getAABBSize(name)
    local info = self:getAnimationInfos(name)
    if info then
        return info.aabb
    end
    return false
end

function M:getDisPlayFrames(name)
    local info = self:getAnimationInfos(name)
    if info then
        local list = {}
        local displayFrame = info.animation[1].slot[1].displayFrame
        local display = info.skin[1].slot[1].display
        for i,v in ipairs(displayFrame) do
            local value = v.value and (v.value + 1) or 1
            table.insert( list, display[value] )
        end
        return list
    end
    return false
end
----
function M:createFrames(atlas,name)
    if atlas then
        local displayFrameList = self:getDisPlayFrames(name)
        local frames = {}
        for i,v in ipairs(displayFrameList) do
            local frame = atlas:createFrame(v.name)
            table.insert( frames,frame )
        end
        return frames
    end
    return false
end

function M:createAnimation(atlas,name)
    local frames = self:createFrames(atlas,name)
    if frames then
        local frameRate = self:getAnimationRate(name) or 1/12
        local animation = display.newAnimation(frames,1/frameRate)

        return animation
    end
    return false

end

return M