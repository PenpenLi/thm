
local M = class("GameModule", View)

function M:onCreate(params)

	local scene = require("Modules.Scene.MainUi.MainMenuScene").create(params)
    self:addChild(scene)
    
end


return M
