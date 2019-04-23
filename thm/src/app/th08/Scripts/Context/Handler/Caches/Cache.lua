local M = {}
local CacheManager = THSTG.CacheManager

setmetatable(M, {
	__index = function(_, k)
		return CacheManager.getCache(k)
	end
})

function M.register(name,classPath)
    CacheManager.addCache(name,classPath)
end
-----------
--由于有时序关系,在这里添加也行




return M
