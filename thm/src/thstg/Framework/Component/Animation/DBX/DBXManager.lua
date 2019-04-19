local DBXAtlas = require "thstg.Framework.Component.Animation.DBX.DBXAtlas"
local DBXSkeleton = require "thstg.Framework.Component.Animation.DBX.DBXSkeleton"

module(..., package.seeall)
local _atlasCahce = {}
local _skeletonCahce = {}

function loadDBXFile(texPath,skePath)
    if texPath ~= "" then
        local atlas = DBXAtlas.new(texPath)
        if atlas then
            local name = atlas:getAtlasName()
            _atlasCahce[name] = atlas

        end
    end

    if skePath ~= "" then
        local sketloe = DBXSkeleton.new(skePath)
        if sketloe then
            local name = sketloe:getSkeletonName()
            _skeletonCahce[name] = sketloe

        end
    end
end

function getAtlas(name)
    return _atlasCahce[name]
end

function getSkeleton(name)
    return _skeletonCahce[name]
end
---
function createTexture(altasName,texName)
    local atlas = getAtlas(altasName)
    if atlas then
        return atlas:createTexture(texName)
    end
    return nil
end

function createFrame(altasName,texName)
    local atlas = getAtlas(altasName)
    if atlas then
        return atlas:createFrame(texName)
    end
    return nil
end

function createFrames(altasName,aniName)
    local atlas = getAtlas(altasName)
    if atlas then
       local skeleton = getSkeleton(altasName)
       if skeleton then
            return skeleton:createFrames(atlas,aniName)
       end
    end
    return nil
end

function createAnimation(altasName,aniName)
    local atlas = getAtlas(altasName)
    if atlas then
       local skeleton = getSkeleton(altasName)
       if skeleton then
            return skeleton:createAnimation(atlas,aniName)
       end
    end
    return nil
end

function createAnimate(altasName,aniName)
    local animation = createAnimation(altasName,aniName)
    if animation then
        return cc.Animate:create(animation)
    end
    return nil
end

function createAnime(altasName,name)
    local atlas = getAtlas(altasName)
    if atlas then
       local skeleton = getSkeleton(altasName)
       if skeleton then
            local animate = createAnimate(altasName,name)
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
    _atlasCahce = {}
    _skeletonCahce = {}
end