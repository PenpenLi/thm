module("Cache", package.seeall)

-- testCache = require("Scripts.Context.Game.Modules.Test.TestCache")
-- menuCache = require("Scripts.Context.Game.Modules.Menu.MenuCache")
-- settingCache = require("Scripts.Context.Game.Modules.Setting.SettingCache")
roleCache = require("Scripts.Context.Game.Modules.Role.RoleCache")
-- selectionCache = require("Scripts.Context.Game.Modules.Selection.SelectionCache")
-- loadingCache = require("Scripts.Context.Game.Modules.Loading.LoadingCache")
stageCache = require("Scripts.Context.Game.Modules.Stage.StageCache")
---
function clear()
    -- testCache.clear()
    -- settingCache.clear()
    roleCache.clear()
    -- selectionCache.clear()
    -- loadingCache.clear()
    -- loadingCache.clear()
    stageCache.clear()
end