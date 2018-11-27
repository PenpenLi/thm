module("GameController", package.seeall)

local _ctrls = {}

--
local function register(moduleType, classPath)
	local Class = require(classPath)
	_ctrls[moduleType] = Class.new()
end


function init()
    --模块注册
	register(ModuleType.TEST, "Scripts.Game.Modules.Test.TestController")
end

function getCtrl(moduleType)
	-- print(120,"moduleType: ",moduleType)
	return _ctrls[moduleType]
end

function clear()
	for k, v in pairs(_ctrls) do
		v:hide()
		v:dispose()
	end
	_ctrls = {}
end
