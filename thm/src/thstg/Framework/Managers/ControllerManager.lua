module("ControllerManager", package.seeall)

local _ctrls = {}

--
function register(moduleType, classPath)
	local Class = require(classPath)
	_ctrls[moduleType] = Class.new()
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
