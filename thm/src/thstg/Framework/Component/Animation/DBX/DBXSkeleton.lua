local DBXUtil = require "thstg.Framework.Component.Animation.DBX.DBXUtil"
local M = class("DBXSkeleton")

function M:ctor(path)
    self._oriInfo = false

    self:load(path)
end

function M:load(path)
    if not path or path == "" then return false end

    local jsonStr = DBXUtil.loadJsonFile(path)
    self._oriInfo = DBXUtil.parseSkeletonMap(jsonStr)
 
    if self._oriInfo then
        return true
    end

    return false
end
----
function M:getSkeletonName()
    if self._oriInfo then
        return self._oriInfo.name
    end
    return ""
end

function M:getArmatureInfos(name)
    if self._oriInfo then 
        return self._oriInfo.armature and self._oriInfo.armature[name]
    end
    return false
end

function M:getAnimationNameList()
    local names = {}
    local armatureInfo = self._oriInfo.armature
    if armatureInfo then
        for k,_ in pairs(armatureInfo) do
            table.insert(names, k)
        end
    end
    return names
end

function M:getAnimationRate(name)
    local info = self:getArmatureInfos(name)
    if info then
        return info.frameRate
    end
    return 0
end

function M:getAnimationTimes(name)
    local info = self:getArmatureInfos(name)
    if info then
        return info.animation[1].playTimes
    end
    return 0
end

function M:getAnimationLength(name)
    local info = self:getArmatureInfos(name)
    if info then
        return info.animation[1].duration
    end
    return 0
end

function M:getAnimationDuration(name)
    if self:getAnimationRate(name) == 0 then
        return 0
    end
    return self:getAnimationLength()/self:getAnimationRate(name)
end

function M:getAABBSize(name)
    local info = self:getArmatureInfos(name)
    if info then
        return info.aabb
    end
    return false
end

function M:getDisPlayFrames(name)
    local info = self:getArmatureInfos(name)
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
        if displayFrameList then
            local frames = {}
            for i,v in ipairs(displayFrameList) do
                local frame = atlas:createFrame(v.name)
                table.insert( frames,frame )
            end
            return frames
        end
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