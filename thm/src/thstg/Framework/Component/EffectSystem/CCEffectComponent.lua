--TODO:
function newEffectNode(params)
    return cc.NodeGrid:create()   --特效的载体
end
----------
----------
--3D晃动的特效
function newShaky3D(params) 
    return cc.Shaky3D:create(5.0,cc.size(50,50),15,false)
end

--3D瓷砖晃动特效
function newShakyTiles3D(params)
    return cc.ShakyTiles3D:create(5.0,cc.size(200,200),2,false)
end

function newWaves(params)
    return cc.Waves:create(5, cc.size(10, 10), 10, 20, true, true)
end

--3D水波纹特效 CCWaves3D
function newWaves3D(params)
    return cc.Waves3D:create(5, cc.size(10, 10), 10, 20)
end

--3D瓷砖波动特效 
function newWavesTiles3D(params)
    return cc.WavesTiles3D:create(5, cc.size(10, 10), 10, 20)
end

--X轴 3D反转特效 
function newFilpX(params)
    return cc.FlipX:create(5)
end

--Y轴3D反转特效
function newFilpY(params)
    return cc.FlipY:create(5)
end

--凸透镜特效
function newLens3D(params)
    return cc.Lens3D:create(2, cc.size(10, 10),cc.p(240, 160), 240)
end

--水波纹特效 
function newRipple3D(params)
    return cc.Ripple3D:create(5, cc.size(10, 10), cc.p(240, 160), 240, 4, 160)
end

--液体特效
function newLiquid(params)
    return cc.Liquid:create(5, cc.size(10, 10), 4, 20)
end

--扭曲旋转特效  
function newTwirl(params)
    return cc.Twirl:create(50, cc.size(10, 10), cc.p(240, 160), 2, 2.5)
end

--破碎的3D瓷砖特效  
function newShatteredTiles3D(params)
    return cc.ShatteredTiles3D:create(15, cc.size(10, 10), 50, true)
end

--瓷砖洗牌特效  
function newShuffle(params)
    return cc.ShuffleTiles:create(5, cc.size(50, 50), 50)
end 

--部落格效果,从左下角到右上角  
function newFadeOutTRTiles(params)
    return cc.FadeOutTRTiles:create(5, cc.size(50, 50))
end 

--折叠效果 从下到上  
function newFadeOutUpTiles(params)
    return cc.FadeOutUpTiles:create(5, cc.size(10, 10))
end 

--折叠效果，从上到下  
function newFadeOutDownTiles(params)
    return cc.FadeOutDownTiles:create(5, cc.size(20, 50))
end

--方块消失特效  
function newTurnOffFiels(params)
    return cc.TurnOffTiles:create(5, cc.size(50, 50))
end

--跳动的方块特效  
function newJumpTiles3D(params)
    return cc.JumpTiles3D:create(5, cc.size(20, 20), 5, 20)
end

--分多行消失特效  
function newSplitCols(params)
    return cc.SplitCols:create(5,50)
end

--分多列消失特效  
function newSplitRows(params)
    return cc.SplitRows:create(5,50)
end 

--3D翻页特效  
function newPageTurn3D(params)
    return cc.PageTurn3D:create(5,cc.size(20,20))
end 