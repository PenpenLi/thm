local M = class("AudioComponent",THSTG.ECS.Component)
function M:ctor(tag)
    self.__tag = tag

    M.super.ctor(self)
end
function M:_onName(className,id)
    return className , (self.__tag or id)
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