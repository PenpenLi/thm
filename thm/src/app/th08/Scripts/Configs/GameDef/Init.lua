-- GameDef = setmetatable({},{__index = function (t,k) 
-- 	local tb = require (string.format("Configs.GameDef.%s",k))
-- 	rawset(t,k,tb)
-- 	return tb
-- end})
-- package.loaded["GameDef"] = GameDef--无奈之举，别乱学k

module("GameDef", package.seeall)
require "Scripts.Configs.GameDef.PublicDef"
require "Scripts.Configs.GameDef.StageDef"