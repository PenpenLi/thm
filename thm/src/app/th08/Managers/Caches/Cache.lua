module("Cache", package.seeall)

testCache = require("Modules.Test.TestCache")
gameCache = require("Modules.Game.GameCache")
roleCache = require("Modules.Role.RoleCache")
---
function clear()
    testCache.clear()
    gameCache.clear()
    roleCache.clear()
end