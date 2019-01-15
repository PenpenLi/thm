local M = class("BatmanController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)

    self.batmanType = BatmanType.BATMAN_01
end
----

----
function M:_onUpdate()

end


function M:_onLateUpdate()

end

return M