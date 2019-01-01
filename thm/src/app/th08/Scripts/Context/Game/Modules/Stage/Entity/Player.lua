module(..., package.seeall)

local M = class("Player",StageDefine.PlayerPrefab)
function M:ctor()
    M.super.ctor(self)
    --初始化变量
    self:setName("PLAYER")

end

function M:_onInit()


end


return M