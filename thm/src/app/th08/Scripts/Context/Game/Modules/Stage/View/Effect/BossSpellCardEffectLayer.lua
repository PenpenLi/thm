module(..., package.seeall)

--[[
    参数说明:

]]

local M = {}
function M.create(params)
    params = params or {}
    -------Model-------

   
    -------View-------
    local node = THSTG.UI.newNode()

    local function initLayer()
        --特效
    end

    local function initData()
        --生成一个动画并运行
    end

    local function init()
        initLayer()
        initData()
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