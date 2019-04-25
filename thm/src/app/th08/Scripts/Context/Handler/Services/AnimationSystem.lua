module("AnimationSystem", package.seeall)
local System = THSTG.AnimationSystem

function playTween()

end

function createAnimation(altasName,skeName,aniName)
	local nameKey = getNameKey(altasName,skeName,aniName)
    local animation = display.getAnimationCache(nameKey)
    if not animation then
		local ret = THSTG.AnimationSystem.createAnimation(altasName,skeName,aniName)
        if not ret then return nil
        else
            display.setAnimationCache(nameKey,ret)
        end
        return ret
    end
    return animation
end

function clearCache()
	display.removeUnusedSpriteFrames()
end
