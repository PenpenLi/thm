local M = class("StageScene",cc.Scene)

function M:ctor()
    --舞台层
    self.backgroundLayer = cc.Layer:create()
    --实体层
    self.entityLayer = cc.Layer:create()
    --主体层
    self.mainLayer = cc.Layer:create()
    --窗口层
    self.windowLayer = cc.Layer:create()


    
    self:addChild(self.backgroundLayer)
    self:addChild(self.entityLayer)
    self:addChild(self.mainLayer)
    self:addChild(self.windowLayer)
end




return M