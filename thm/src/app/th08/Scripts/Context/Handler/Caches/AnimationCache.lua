module("AnimationCache", package.seeall)

local function getNameKey(...)
    local keys = {...}
    local keyName = ""
    for _,v in ipairs(keys) do
        keyName = keyName .. v .. "#"
    end
    keyName = THSTG.MD5.string(keyName)

    return keyName
end

function getRes(type,fileName,name)
    local nameKey = getNameKey(type,fileName,name)
    local animation = display.getAnimationCache(nameKey)
    if not animation then
        local ret = ScenePublic.newAnimation({
            texType = type,
            fileName = fileName,
            keyName = name,
        })
        if not ret then return nil
        else
            display.setAnimationCache(nameKey,ret)
        end
        return ret
    end
    return animation
end

----

function clear()
   
end