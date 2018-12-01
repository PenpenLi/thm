module("Cache", package.seeall)

testCache = require("Scripts.Game.Modules.Test.TestCache")
settingCache = require("Scripts.Game.Modules.Setting.SettingCache")
roleCache = require("Scripts.Game.Modules.Role.RoleCache")
---
function clear()
    testCache.clear()
    settingCache.clear()
    roleCache.clear()
end