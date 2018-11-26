module("Cache", package.seeall)

testCache = require("Scripts.Modules.Test.TestCache")
gameCache = require("Scripts.Modules.Game.GameCache")
guiCache = require("Scripts.Modules.GUI.GUICache")
roleCache = require("Scripts.Modules.Role.RoleCache")

---
function clear()
    testCache.clear()
    gameCache.clear()
    guiCache.clear()
    roleCache.clear()
end