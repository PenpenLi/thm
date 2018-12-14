local M = class("LifeComponent",THSTG.ECS.Component)

function M:_onInit()
    self.life = 1       --残机数
    self.blood = 100    --血量
end

return M