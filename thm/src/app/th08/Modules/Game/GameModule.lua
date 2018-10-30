
local M = class("GameModule", View)

function M:ctor()
	self:setLayer(LayerManager.windowLayer)
end

function M:_initRealView(params)

	local window = require("Game.Modules.Activity.ActivityDice.ActivityDiceLayer").create(params)
    return window
    
end


return M
