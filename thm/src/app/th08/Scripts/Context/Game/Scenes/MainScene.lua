local M = class("MainScene",cc.Scene)

function M:ctor()
    --窗口层
    self.mainLayer = cc.Layer:create()



    
    self:addChild(self.mainLayer)
end

return M