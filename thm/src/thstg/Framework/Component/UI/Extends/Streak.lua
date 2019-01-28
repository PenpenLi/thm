module("UI", package.seeall)

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