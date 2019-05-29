local M = class("Animator")

function M:ctor()
    self.runtimeAnimatorController = false
    self.spriteNode = false
end

function M:play(stateName)
    --硬切某个状态
    if self.runtimeAnimatorController then
        self.runtimeAnimatorController:trans(stateName)
    end
end

function M:crossFade(stateName,fadeTime)
    --过渡,等待当前状态结束采取切换
end

function M:setValue(paramName,value)

end

function M:getValue(paramName)
    
end

return M