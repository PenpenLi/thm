module("ModuleManager", package.seeall)
--[[
params = {
	isResident -- 是否常驻
	closeOthers -- 是否关闭其他
	playSound -- 是否播放打开音效
}
]]
function open(moduleType,params)
	params = params or {}
	local ctrl = ControllerHandler.getCtrl(moduleType)
	if not ctrl then 
		return
	end
end

function close(moduleType)
	local ctrl = GameController.getCtrl(moduleType)
	if not ctrl or not ctrl:isShow() then
		return
	end
end

--[[ 关闭所有模块
allType
nil 都关闭
1 - 只关闭普通模块
2 - 只关闭常驻模块
]]
function closeAll(allType)

end