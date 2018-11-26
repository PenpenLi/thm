
local M = class("GameModule", View)

function M:ctor()
    --TODO:决定进模块放到那个层
	self:setLayer(LayerManager.windowLayer)
end

function M:_initRealView(params)
    --启动第一个UI
	local layer = require("Scripts.Modules.GUI.MainUi.MainMenu.MainMenuLayer").create(params)
    return layer
    
end


return M
