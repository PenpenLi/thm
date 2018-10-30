module("SCENE", package.seeall)

--自定义的精灵帧创建
local function newHVFrames(params ,isVertical)
	params = params or {}
	isVertical = isVertical or params.isVertical or false
	params.source = params.source or ""
	params.length = params.length or 0
	params.isReversed = params.isReversed or false

	local source = params.source
	local length = params.length
	local isReversed = params.isReversed

	local frames = {}
	local step = 1
	local begin = 1
	local last = begin + length - 1
	if isReversed then
		last, begin = begin, last
		step = -1
	end

	local texture,texRect = SCENE.loadTexture(source)
	
	local frameSize = cc.size(texRect.width,texRect.height)
	if isVertical then
		frameSize.height = frameSize.height / length
	else
		frameSize.width = frameSize.width / length
	end
	
	local frameRect = cc.rect(texRect.x,texRect.y,frameSize.width,frameSize.height)
	for index = begin, last, step do
		if isVertical then
			frameRect.y = texRect.y + frameRect.height * (index - 1)
		else
			frameRect.x = texRect.x + frameRect.width * (index - 1)
		end
		
		local frame = cc.SpriteFrame:createWithTexture(texture, frameRect)

		frames[#frames + 1] = frame
	end
	return frames
end

--创建Sheet精灵帧
-- @param	source			[string]	资源路径
-- @param	length			[number]	长度
-- @param	isVertical		[boolean]	是否垂直的	默认为false
-- @param	isReversed		[boolean]	是否翻转	默认为false

function newFramesBySheet(params)
	params = params or {}
	assert(type(params.pattern) == "string", "[UI] newSheetFrames() invalid params")
	params.length = params.length or 0
	params.isVertical = params.isReversed or false
	params.isReversed = params.isReversed or false
	
	return newHVFrames(params,params.isVertical)
end

--通过文件名模式创建精灵帧
-- @param	pattern				[string]	文件名模式
-- @param	begin				[number]	开始下标	默认为1
-- @param	length				[number]	长度	
-- @param	isReversed			[boolean]	是否翻转	默认为false
function newFramesByPattern(params)
	params = params or {}
	assert(type(params.pattern) == "string", "[UI] newFileFrames() invalid params")
	params.begin = params.begin or 1
	params.length = params.length or 0
	params.isReversed = params.isReversed or false
	
	return display.newFrames(params.pattern, params.begin, params.length, params.isReversed)
end

--通过文件数组创建精灵帧
-- @param	array				[table]		文件名模式
-- @param	begin				[number]	开始下标	默认为1
-- @param	length				[number]	长度		默认数组长度
-- @param	isReversed			[boolean]	是否翻转	默认为false
function newFramesByFiles(params)
	params = params or {}
	assert(type(params.array) == "table", "[UI] newArrayFrames() invalid params")
	params.begin = params.begin or 1
	params.length = params.length or #params.array
	params.isReversed = params.isReversed or false

	local frames = {}
	local step = 1
	local begin = params.begin
	local last = begin + params.length - 1
	if isReversed then
		last, begin = begin, last
		step = -1
	end

	for index = begin, last, step do
		local sprite = cc.Sprite:create(params.array[index])
		if sprite then
			frames[#frames + 1] = sprite
		end
	end
	

	return frames
end



