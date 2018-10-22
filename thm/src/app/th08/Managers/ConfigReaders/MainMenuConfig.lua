module("MainMenuConfig", package.seeall)

local _Dict = false

local function getDict()
    if not _Dict then
        _Dict = require("Configs.Handwork.MainMenuMisc")
    end
    return _Dict
end

function getMainMenuInfo()
    local dict = getDict()
    return dict.menus
end