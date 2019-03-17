local DBXAtlas = "thstg.Framework.Component.Animation.DBX.DBXAtlas"
local DBXSkeleton = "thstg.Framework.Component.Animation.DBX.DBXSkeleton"

module("DBXManager", package.seeall)
local _atlasCahce = {}
local _sketoneCahce = {}

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
            _sketoneCahce[name] = sketloe
        end
    end
end

function getAtlas(name)
    return _atlasCahce[name]
end

function getSketlone(name)
    return _sketoneCahce[name]
end
---
function createTexture(altasName,texName)
    local atlas = self:getAtlas(altasName)
    if atlas then
        return atlas:createTexture(texName)
    end
    return nil
end

function createFrame(altasName,texName)
    local atlas = self:getAtlas(altasName)
    if atlas then
        return atlas:createFrame(texName)
    end
    return nil
end

function createFrames(altasName,aniName)
    local atlas = self:getAtlas(altasName)
    if atlas then
       local sketlone = self:getSketlone(altasName)
       if sketlone then
            return sketlone:createFrames(atlas,aniName)
       end
    end
    return nil
end

function createAnimation(altasName,aniName)
    local atlas = self:getAtlas(altasName)
    if atlas then
       local sketlone = self:getSketlone(altasName)
       if sketlone then
            return sketlone:createAnimation(atlas,aniName)
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

function clear()
    _atlasCahce = {}
    _sketoneCahce = {}
end