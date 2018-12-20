local M = class("AudioComponent",THSTG.ECS.Component)
function M:ctor()
    M.super.ctor(self)

end
function M:_onClass(className,id)
    return className , id
end

function M:_onInit()
    self.isLoop = false
    self.volume = 100

    self.source = nil
    self.playOnAwake = true
end


---
function M:play()

end

return M