module("Cache", package.seeall)

testCache = require("Scripts.Game.Modules.Test.TestCache")
gameCache = require("Scripts.Game.Modules.Game.GameCache")

---
function clear()
    testCache.clear()
    gameCache.clear()
end