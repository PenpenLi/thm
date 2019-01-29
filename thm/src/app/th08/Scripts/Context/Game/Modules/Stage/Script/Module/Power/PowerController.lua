local M = class("PowerController",THSTG.ECS.Script)

function M:_onInit()
    self.maxPower = 100     --最大火力值
    self.power = 0          --火力值
end

function M:getPower()
    return self.power
end

function M:setPower(val)
    self.power = val
end

return M