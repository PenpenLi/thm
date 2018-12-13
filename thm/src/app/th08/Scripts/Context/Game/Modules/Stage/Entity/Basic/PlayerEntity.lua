--玩家实体
module(..., package.seeall)

local M = class("PlayerEntity", StageDefine.LivedEntity)
function M:_onInit()
    self.super._onInit(self)


    self._life = 3 --残机数
    
end
------


return M
