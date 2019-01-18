local M = class("EmitterController",StageDefine.EmitterController)

function M:_onInit()
    self.shotInterval = 0.10                        --发射子弹的时间间隔
end


return M