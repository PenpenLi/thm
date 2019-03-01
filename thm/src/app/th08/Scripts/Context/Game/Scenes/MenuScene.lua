local M = class("MenuScene",cc.Scene)

function M:ctor()
    --窗口层
    self.mainLayer = cc.Layer:create()



    
    self:addChild(self.mainLayer)
    --
    self:onNodeEvent("enter", function ()
        THSTG.MVCManager.openModule(ModuleType.MENU)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.MVCManager.closeModule(ModuleType.MENU)
    end)
end

return M