module("ModuleCache", package.seeall)
local CacheManager = THSTG.CacheManager

setmetatable(ModuleCache, {
	__index = function(_, k)
		return CacheManager.getCache(k)
	end
})

function register(name,classPath)
    CacheManager.addCache(name,classPath)
end

function clear()
	CacheManager.clearAll()
end
-----------
--由于有时序关系,在这里添加也行
register("Test","Scripts.Context.Game.Modules.Test.TestCache")
register("Stage","Scripts.Context.Game.Modules.Stage.StageCache")
register("MainUI","Scripts.Context.Game.Modules.MainUI.MainUICache")