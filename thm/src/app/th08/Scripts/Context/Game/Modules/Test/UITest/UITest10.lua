

--*****************************************************************--
--3D晃动的特效
local shaky3d = function () 
    return cc.Shaky3D:create(5.0,cc.size(50,50),15,false)
end
--3D瓷砖晃动特效
local shakyTiles3D = function ()
    return cc.ShakyTiles3D:create(5.0,cc.size(200,200),2,false)
end

local wave = function()
    return cc.Waves:create(5, cc.size(10, 10), 10, 20, true, true)
end

--3D水波纹特效 CCWaves3D
local waves3D = function()
    return cc.Waves3D:create(5, cc.size(10, 10), 10, 20)
end

--3D瓷砖波动特效 
local wavesTiles3D = function()
    return cc.WavesTiles3D:create(5, cc.size(10, 10), 10, 20)
end

--X轴 3D反转特效 
local filpX = function()
    return cc.FlipX:create(5)
end

--Y轴3D反转特效
local filpY = function()
    return cc.FlipY:create(5)
end

--凸透镜特效
local lens3D = function()
    return cc.Lens3D:create(2, cc.size(10, 10),cc.p(240, 160), 240)
end

--水波纹特效 
local ripple3D = function()
    return cc.Ripple3D:create(5, cc.size(10, 10), cc.p(240, 160), 240, 4, 160)
end

--液体特效
local liquid = function()
    return cc.Liquid:create(5, cc.size(10, 10), 4, 20)
end

--扭曲旋转特效  
local twirl = function()
    return cc.Twirl:create(50, cc.size(10, 10), cc.p(240, 160), 2, 2.5)
end

--破碎的3D瓷砖特效  
local shatteredTiles3D = function()
    return cc.ShatteredTiles3D:create(15, cc.size(10, 10), 50, true)
end

--瓷砖洗牌特效  
local shuffle = function()
    return cc.ShuffleTiles:create(5, cc.size(50, 50), 50)
end 

--部落格效果,从左下角到右上角  
local fadeOutTRTiles = function()
    return cc.FadeOutTRTiles:create(5, cc.size(50, 50))
end 

--折叠效果 从下到上  
local fadeOutUpTiles = function()
    return cc.FadeOutUpTiles:create(5, cc.size(10, 10))
end 

--折叠效果，从上到下  
local fadeOutDownTiles = function()
    return cc.FadeOutDownTiles:create(5, cc.size(20, 50))
end

--方块消失特效  
local turnOffFiels = function()
    return cc.TurnOffTiles:create(5, cc.size(50, 50))
end

--跳动的方块特效  
local jumpTiles3D = function()
    return cc.JumpTiles3D:create(5, cc.size(20, 20), 5, 20)
end

--分多行消失特效  
local splitCols = function()
    return cc.SplitCols:create(5,50)
end

--分多列消失特效  
local splitRows = function()
    return cc.SplitRows:create(5,50)
end 

--3D翻页特效  
local pageTurn3D = function()
    return cc.PageTurn3D:create(5,cc.size(20,20))
end 
--*****************************************************************--

local ActionList = {
    shaky3d,
    shakyTiles3D,
    wave,
    waves3D,
    wavesTiles3D,
    lens3D,
    ripple3D,
    liquid,
    twirl,
    shatteredTiles3D,
    shuffle,
    fadeOutTRTiles,
    fadeOutUpTiles,
    fadeOutDownTiles,
    turnOffFiels,
    jumpTiles3D,
    splitCols,
    splitRows,
    pageTurn3D,
}

local ActionListName = {
    '3D晃动的特效:Shaky3D',
    '3D瓷砖晃动特效:ShakyTiles3D',
    '波动特效:Waves',
    '3D水波纹特效 Waves3D',
    '3D瓷砖波动特效 :WavesTiles3D',
    '凸透镜特效:Lens3D',
    '水波纹特效 :Ripple3D',
    '液体特效:Liquid',
    '扭曲旋转特效:Twirl',
    '破碎的3D瓷砖特效  :ShatteredTiles3D',
    '瓷砖洗牌特效:ShuffleTiles',
    '部落格效果,从左下角到右上角  :fadeOutTRTiles',
    '折叠效果 从下到上  :fadeOutUpTiles',
    '折叠效果，从上到下  :fadeOutDownTiles',
    '方块消失特效：TurnOffTiles',
    '跳动的方块特效  :JumpTiles3D',
    '分多行消失特效  :SplitCols',
    '分多列消失特效:splitRows ',
    '3D翻页特效 :PageTurn3D'

}
local M = {}
function M.create()
    -----
    local node = THSTG.UI.newNode()

    -----
    node.visibleSize = cc.Director:getInstance():getVisibleSize()
    node.origin = cc.Director:getInstance():getVisibleOrigin()
    
    local sprite = cc.Sprite:create("HelloWorld.png")
    sprite:setPosition(240,160)
    local nodegird = cc.NodeGrid:create()   --特效的载体
    nodegird:addChild(sprite)
    node:addChild(nodegird)
    
    node._nodegird = nodegird 
    node.currentId = 1
    
    local function changeAction()
        if node.currentId > #ActionList then
            node.currentId = 1
        end
        node._nodegird:stopAllActions()
        local fun = ActionList[node.currentId]
        local actionInterval = fun()
        node._nodegird:runAction(actionInterval)
        node._nameLabel:setString(ActionListName[node.currentId])
        node.currentId = node.currentId + 1  
    end
 
    local menuRun = cc.MenuItemFont:create("ChangeAction")
    menuRun:setPosition(0, 0)
    menuRun:registerScriptTapHandler(changeAction)
    local menu = cc.Menu:create(menuRun)
    menu:setPosition(400,50)
    node:addChild(menu,2)
    
    
    local nameLable = cc.Label:create()
    nameLable:setPosition(100,200)
    node:addChild(nameLable,6)
    node._nameLabel = nameLable

    return node
end

return M
