module(..., package.seeall)

local M = class("StageView", THSTG.MVC.View)

function M:ctor()
    M.super.ctor(self)
    
end

function M:_onInit()


end

function M:_onRealView()
    local node = cc.Layer:create()
    node:addTo(THSTG.SceneManager.get(SceneType.MAIN).bottomLayer)

    --游戏逻辑初始化
    local eStageGame = StageDefine.StageGame.new()
    node:addChild(eStageGame)
    
    ---
    return node
end

return M