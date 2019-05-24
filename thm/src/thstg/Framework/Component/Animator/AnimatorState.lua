local M = class("AnimatorState")

function M:ctor()
    self._transitions_ = false
    self.name = false
    self.tag = false

    self.motion = false
    self.speed = false
    self.mirror = false
    self.normalizeTime = false
end

function M:addMotion(motion)
    
end

function M:addTransition(otherState)
    
end

return M