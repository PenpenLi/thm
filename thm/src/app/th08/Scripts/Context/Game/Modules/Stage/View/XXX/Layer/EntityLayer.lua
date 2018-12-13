module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local _uiDanmakuLayer = require("Scripts.Context.Game.Modules.Stage.View.Layer.EntityLayer.DanmakuLayer").create() --弹幕层
    local _uiEnemyLayer = require("Scripts.Context.Game.Modules.Stage.View.Layer.EntityLayer.EnemyLayer").create()  --敌机层
    local _uiPlayerLayer = require("Scripts.Context.Game.Modules.Stage.View.Layer.EntityLayer.PlayerLayer").create() --自机层
   
    -------View-------
    local node = THSTG.UI.newNode()
    node:addChild(_uiDanmakuLayer)
    node:addChild(_uiEnemyLayer)
    node:addChild(_uiPlayerLayer)
  
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