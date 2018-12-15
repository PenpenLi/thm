local M = class("MainScene",cc.Scene)

function M:ctor()
    --窗口层
    self.mainLayer = cc.Layer:create()



    
    self:addChild(self.mainLayer)



    --
    self:onNodeEvent("enter", function ()
        THSTG.ModuleManager.open(ModuleType.TEST)
    end)

    self:onNodeEvent("exit", function ()
        THSTG.ModuleManager.close(ModuleType.TEST)
    end)
end



return M