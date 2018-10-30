module("Cache", package.seeall)

gameCache = require("Modules.Game.GameCache")

---
function clear()
    gameCache.clear()
end