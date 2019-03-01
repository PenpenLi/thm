
module(..., package.seeall)

local _moduleId = 0


--模块的唯一id
function getModuleUID()
	_moduleId = _moduleId + 1
	return _moduleId
end
