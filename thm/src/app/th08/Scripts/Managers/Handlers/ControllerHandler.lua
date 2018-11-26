module("ControllerHandler", package.seeall)

local _ctrls = {}

--
local function register(moduleType, classPath)
	local Class = require(classPath)
	_ctrls[moduleType] = Class.new()
end


function init()
    --模块注册
	register(ModuleType.TEST, "Scripts.Modules.Test.TestController")
	register(ModuleType.GAME, "Scripts.Modules.Game.GameController")
	register(ModuleType.ROLE, "Scripts.Modules.Role.RoleController")
	register(ModuleType.GUI, "Scripts.Modules.GUI.GUIController")
end

function getCtrl(moduleType)
	return _ctrls[moduleType]
end

function clear()
	for k, v in pairs(_ctrls) do
		v:hide()
		v:dispose()
	end
	_ctrls = {}
end
