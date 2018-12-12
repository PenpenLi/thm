local M = class("StageScene",cc.Scene)

function M:ctor()
    --舞台层
    self.backgroundLayer = cc.Layer:create()

    self.mainLayer = cc.Layer:create()

    self.windowLayer = cc.Layer:create()



    self:addChild(self.backgroundLayer)
    self:addChild(self.mainLayer)
    self:addChild(self.windowLayer)
end




return M