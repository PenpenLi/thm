
local ERoleType = Const.Stage.ERoleType
local M = class("MarisaController",StageDefine.PlayerController)


function M:_onInit()
    M.super._onInit(self)

    self.roleType = ERoleType.Marisa
end

function M:shot()
    M.super.shot(self)


end

function M:_onStart()
    M.super._onStart(self)
    --
   
end


return M