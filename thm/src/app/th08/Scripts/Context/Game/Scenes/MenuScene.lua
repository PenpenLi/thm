local M = class("MenuScene",cc.Scene)

function M:ctor()
    --窗口层
    self.mainLayer = cc.Layer:create()



    
    self:addChild(self.mainLayer)
    --
    self:onNodeEvent("enter", function ()
        THSTG.ModuleManager.open(ModuleType.MENU)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.ModuleManager.close(ModuleType.MENU)
    end)
end

return M