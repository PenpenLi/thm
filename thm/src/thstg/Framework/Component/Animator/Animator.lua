local M = class("Animator")

function M:ctor()
    self.runtimeAnimatorController = false
end

function M:play(stateName)
    --进入某个状态
    if self.runtimeAnimatorController then

    end
end

function M:crossFade(stateName,fadeTime)

end


return M