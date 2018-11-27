module("Cache", package.seeall)

testCache = require("Scripts.Game.Modules.Test.TestCache")
gameCache = require("Scripts.Game.Modules.Game.GameCache")
guiCache = require("Scripts.Game.Modules.GUI.GUICache")
roleCache = require("Scripts.Game.Modules.Role.RoleCache")

---
function clear()
    testCache.clear()
    gameCache.clear()
    guiCache.clear()
    roleCache.clear()
end