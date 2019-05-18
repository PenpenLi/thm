--TODO:
function newNodeGrid(action)
    local node = cc.NodeGrid:create()
    node._effect = action

    --
    function node:play()
        node:runAction(self._effect)
    end

    function node:reset()
    
    end

    function node:attack(child)
        local parent = child:getParent()
        child:setParent(parent)
        child:setParent(self)
    end

    function node:setEffect(effect)
        self._effect = effect
    end

    function node:getEffect()
        return self._effect
    end

    return node

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


-----
-- 新建拖尾效果
-- @param	x			[number]		x
-- @param	y			[number]		y
-- @param   fade		[number]		拖尾渐隐时间（秒）
-- @param   minSeg		[number]		最小的片段长度（渐隐片段的大小）。拖尾条带相连顶点间的最小距离。
-- @param   width		[number]		渐隐条带的宽度。
-- @param   color		[cc.c4b]		片段颜色值。
-- @param   src/texture			[string]		纹理图片的文件名。
function newMotionStreak(params)
	params = params or {}
	--
	params.fade = params.fade or 1
	params.minSeg = params.minSeg or 1
	params.width = params.width or 5
	params.color = params.color or cc.c4b(0xFF, 0, 0, 0xFF)
	params.src = params.src or ""

	local node = cc.MotionStreak:create(params.fade,params.minSeg,params.width,params.color,params.src or paarams.texture)
	node:setPosition(cc.p(params.x or display.cx,params.y or display.cy))

	return node
end