thstg = thstg or {}

--[[
-- 加载用户入口文件
-- @param	gameName			[string]	游戏版本名称
]]
function thstg.load(gameName)
    local configPath = "app."..gameName..".Entry"
    local configTab = require(configPath)
    return configTab or {}
end
