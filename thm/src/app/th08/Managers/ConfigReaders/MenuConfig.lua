module("MenuConfig", package.seeall)

local _Dict = false

local function getDict()
    if not _Dict then
        _Dict = require("Configs.Handwork.Menu")
    end
    return _Dict
end

function getMainMenuInfo()
    local dict = getDict()
    return dict.main_menu
end