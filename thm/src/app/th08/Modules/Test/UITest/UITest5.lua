module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------

   
    -------View-------
    local node = THSTG.UI.newNode()

    --弹入对话框
    --弹出对话框-回调
    --换边说话-明暗处理
    --换人说话
    
    --文本
    --打字效果
    
    --自动快进

    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node
end

return M