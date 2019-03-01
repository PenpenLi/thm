local M = class("MainScene",cc.Scene)

function M:ctor()
    --窗口层
    self.mainLayer = cc.Layer:create()



    
    self:addChild(self.mainLayer)



    --
    self:onNodeEvent("enter", function ()
        THSTG.MVCManager.openModule(ModuleType.TEST)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.MVCManager.closeModule(ModuleType.TEST)
    end)
end



return M