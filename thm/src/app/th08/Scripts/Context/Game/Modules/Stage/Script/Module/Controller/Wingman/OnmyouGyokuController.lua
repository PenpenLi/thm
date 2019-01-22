local M = class("OnmyouGyokuController",StageDefine.WingmanController)

function M:_onInit()
    M.super._onInit(self)

    --存储子弹
end

function M:_onAdded(entity)
    --僚机环绕效果不是由自身发起的
   
end

function M:_onUpdate()

end



return M