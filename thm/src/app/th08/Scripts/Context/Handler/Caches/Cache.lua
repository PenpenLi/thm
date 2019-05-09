module("Cache", package.seeall)
local CacheManager = THSTG.CacheManager

setmetatable(Cache, {
	__index = function(_, k)
		return CacheManager.getCache(k)
	end
})

function register(name,classPath)
    CacheManager.addCache(name,classPath)
end
-----------
--由于有时序关系,在这里添加也行
register("stageCache","Scripts.Context.Game.Modules.Stage.StageCache")
register("mainUICache","Scripts.Context.Game.Modules.MainUI.MainUICache")