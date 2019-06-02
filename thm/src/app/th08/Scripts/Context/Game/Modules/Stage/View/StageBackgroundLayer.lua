
local M = {}
function M.create(params)
    params = params or {}
    -------Model-------
    local _uiNormalNode = false     --正常情况下的背景
    local _uiSPNode = false         --发动符卡时的背景
   
    -------View-------
    local node = THSTG.UI.newNode()

    _uiNormalNode = THSTG.UI.newNode()
    node:addChild(_uiNormalNode)

    _uiSPNode = THSTG.UI.newNode()
    node:addChild(_uiSPNode)

    local function init()
     
    end
    init()
    -------Controller-------
    node:onNodeEvent("enter", function ()
       
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M