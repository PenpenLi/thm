local M = {}
setmetatable(M, {__index = THSTG.AnimationSystem})
local DBXManager = THSTG.ANIMATION.DBXManager


function M.loadDBXFile(...) DBXManager.loadDBXFile(...) end

function M.createAnimation(altasName,skeName,aniName)
    local animation = AnimationCache.get({altasName,skeName,aniName})
    if not animation then
		animation = DBXManager.createAnimation(altasName,skeName,aniName)
        if not animation then return nil end
        
        AnimationCache.add({altasName,skeName,aniName},animation)
    end
    return animation
end

function M.getSkeleton(...) return DBXManager.getSkeleton(...) end


return M