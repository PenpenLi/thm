local M = class("OnmyouGyokuController",StageDefine.WingmanController)

function M:_onInit()
    M.super._onInit(self)

    self.wingmanType = WingmanType.ONMYOUGYOKU
    --存储子弹
end

function M:_onAdded(entity)
   M.super._onAdded(self,entity)
end

function M:_onUpdate()
    --TODO:属于追踪弹,搜索自身8格子范围内的敌人锁定追踪
end



return M