local M = class("AudioComponent",THSTG.ECS.Component)

function M:ctor(...)
    M.super.ctor(self,...)

end


function M:_onInit()
    self.isLoop = false
    self.volume = 100

    self.source = nil
    self.playOnAwake = false

    self._id = -1
end


---
function M:play()
    assert(self.source, string.format("[%s] The file path cannot be empty",M.__cname))
    self._id = THSTG.AudioMgr.playSound(self.source,self.isLoop)
end

function M:stop()
    THSTG.AudioMgr.stopSound(self._id)
    self._id = -1
end

function M:pause()
    THSTG.AudioMgr.pauseSound(self._id)
end

function M:resume()
    THSTG.AudioMgr.resumeSound(self._id)
end

function M:getVolume()
    local val = THSTG.AudioMgr.getSoundVolume(self._id)
    self.volume = val
end

function M:setVolume(val)
    self.volume = val
    THSTG.AudioMgr.setSoundVolume(self._id,val)
end

function M:_onStart()
    if self.playOnAwake then
        self:play()
    end
end

function M:_oneEnd()
    self:stop()
end

---

function M:_onClass(className,id)
    return className, id
end
return M