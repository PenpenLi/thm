module(..., package.seeall)
local M = class("EditorModule", THSTG.MVC.Module)

function M:_initRealView()
    self:setViewParent(LayerManager.guiLayer)
    
  
end

function M:_onInit()

end


return M