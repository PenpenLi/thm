-- module("PARTICLE", package.seeall)


-- 新建粒子
-- @param	x			[number]		x
-- @param	y			[number]		y
-- @param   width		[number]		宽
-- @param   height		[number]		高
-- @param	anchorPoint [cc.p]			锚点
-- @param	src			[string]		特效文件
-- @param	isLoop		[boolean]		是否循环
-- @param	duration	[number]		持续时间
-- @param	posType		[enum]			位置类型

function newParticleSystem(params)
	params = params or {}
	params.isLoop = params.isLoop or false
	params.duration = params.isLoop and (-1) or (params.duration)
	params.posType = params.posType or cc.POSITION_TYPE_RELATIVE
	local system = cc.ParticleSystemQuad:create(params.src)
	system:setPosition(params.x or 0, params.y or 0)
	if params.anchorPoint then
		system:setAnchorPoint(params.anchorPoint)
	end

	if params.duration then
		system:setDuration(params.duration)
	end

	if params.width and params.height then
		system:setContentSize(cc.size(params.width, params.height))
	end

	system:setAutoRemoveOnFinish(not params.isLoop)
    system:setPositionType(params.posType)
    --
    function system:play()
        self:resetSystem()
    end
    function system:stop()
        self:stopSystem()
    end
	--
	system:stop()

	return system
end
