module("AnimationCache", package.seeall)

local function getNameKey(tags)
    if type(tags) ~= "table" then tags = {tags} end
    local keys = tags
    local keyName = ""
    for _,v in ipairs(keys) do
        keyName = keyName .. v .. "#"
    end
    keyName = THSTG.MD5.string(keyName)

    return keyName
end

function addAnimation(tags,animation)
    local nameKey = getNameKey(tags)
    display.setAnimationCache(nameKey,animation)
end

function getAnimation(tags)
    local nameKey = getNameKey(tags)
    return display.getAnimationCache(nameKey)
end

function removeAnimation(tags)
    local nameKey = getNameKey(tags)
    display.removeAnimationCache(nameKey)
end

function clear()

end