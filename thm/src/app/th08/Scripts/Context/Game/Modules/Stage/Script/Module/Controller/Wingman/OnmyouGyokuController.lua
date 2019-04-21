local EWingmanType = GameDef.Stage.EWingmanType
local M = class("OnmyouGyokuController",StageDefine.WingmanController)

function M:_onInit()
    M.super._onInit(self)

    self.wingmanType = EWingmanType.OnmyouGyoku
    --存储子弹
end

function M:_onAdded(entity)
   M.super._onAdded(self,entity)
end

function M:_onStart()

end

return M