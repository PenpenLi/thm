local DBXAtlas = require "thstg.Framework.Component.Animation.DBX.DBXAtlas"
local DBXSkeleton = require "thstg.Framework.Component.Animation.DBX.DBXSkeleton"

module(..., package.seeall)
local _fileCache = {}
local _atlasCahce = {}
local _skeletonCahce = {}
local _skeletonTexMap = {} --图集映射

function loadDBXFile(texPath,skePath)
    local atlas = false
    if texPath and texPath ~= "" then
        if not _fileCache[texPath] then
            atlas = DBXAtlas.new(texPath)
            if atlas then
                local name = atlas:getAtlasName()
                _atlasCahce[name] = atlas
                _fileCache[texPath] = true
            end
        end
    end

    local sketloe = false
    if skePath and skePath ~= "" then
        if not _fileCache[skePath] then
            local sketloe = DBXSkeleton.new(skePath)
            if sketloe then
                local name = sketloe:getSkeletonName()
                _skeletonCahce[name] = sketloe
                if atlas then
                    _skeletonTexMap[name] = atlas
                    _fileCache[skePath] = true
                end
            end
        end
    end

    return atlas,sketloe
end

function getAtlas(name)
    return _atlasCahce[name]
end

function getSkeleton(name)
    return _skeletonCahce[name]
end
---
function createTexture(altasName,frameName)
    local atlas = getAtlas(altasName)
    if atlas then
        return atlas:createTexture(frameName)
    end
    return nil
end

function createFrame(altasName,frameName)
    local atlas = getAtlas(altasName)
    if atlas then
        return atlas:createFrame(frameName)
    end
    return nil
end


function createFrames(skeName,aniName)
    local atlas = _skeletonTexMap[skeName]
    if atlas then
       local skeleton = getSkeleton(skeName)
       if skeleton then
            return skeleton:createFrames(atlas,aniName)
       end
    end
    return nil
end

function createAnimation(skeName,aniName)
    local atlas = _skeletonTexMap[skeName]
    if atlas then
        local skeleton = getSkeleton(skeName)
        if skeleton then
            local animation = skeleton:createAnimation(atlas,aniName)
            return animation
        end
    end
    
    return nil
end

function createAnimate(skeName,aniName)
    local animation = createAnimation(skeName,aniName)
    if animation then
        return cc.Animate:create(animation)
    end
    return nil
end

function createAnime(skeName,aniName)
    local atlas = _skeletonTexMap[skeName]
    if atlas then
       local skeleton = getSkeleton(skeName)
       if skeleton then
            local animate = createAnimate(skeName,aniName)
            local times =  skeleton:getAnimationTimes()
            if times > 0 then
                local seq = {}
                for i = 1,times do
                    table.insert( seq,animate )
                end
                return cc.Sequence:create(seq)
            elseif times == 0 then
                return cc.RepeatForever:create(animate)
            end
       end
    end
    return nil
end

function clear()
    _fileCache = {}
    _atlasCahce = {}
    _skeletonCahce = {}
    _skeletonTexMap = {}
end