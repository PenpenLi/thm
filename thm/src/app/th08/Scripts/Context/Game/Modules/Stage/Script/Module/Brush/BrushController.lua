local M = class("BrushController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

    self.brushSize = cc.size(32,32)
end

-------
-------

function M:_onStart()

end

function M:_onUpdate()
    --子弹擦过精灵框而没有撞到判定点算擦弹
end


function M:_onLateUpdate()

end

return M