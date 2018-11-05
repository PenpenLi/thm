
local M = class("GameModule", View)

function M:onCreate(params)

	local scene = require("Modules.Game.Scene.MainScene").create(params)
    self:addChild(scene)
    
end


return M
