module(..., package.seeall)

local M = {}
function M.create(params)
    -----
    local node = THSTG.UI.newNode()
    local _eStageGame = StageDefine.StageGame.new()
    node:addChild(_eStageGame)
    
    -------Controller-------
    node:onNodeEvent("enter", function ()
    end)

    node:onNodeEvent("exit", function ()
    end)

    return node
end

return M