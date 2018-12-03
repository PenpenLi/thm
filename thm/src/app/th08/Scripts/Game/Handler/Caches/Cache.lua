module("Cache", package.seeall)

testCache = require("Scripts.Game.Modules.Test.TestCache")
menuCache = require("Scripts.Game.Modules.Menu.MenuCache")
settingCache = require("Scripts.Game.Modules.Setting.SettingCache")
roleCache = require("Scripts.Game.Modules.Role.RoleCache")
selectionCache = require("Scripts.Game.Modules.Selection.SelectionCache")

---
function clear()
    testCache.clear()
    settingCache.clear()
    roleCache.clear()
    selectionCache.clear()
end