module(..., package.seeall)

local M = class("Sakuya",StageDefine.PlayerPrefab)

function M:_onInit()
    self.playerMove.roleType = StageDefine.RoleType.REIMU   --初始化变量
end

function M:shot()
    
end

return M