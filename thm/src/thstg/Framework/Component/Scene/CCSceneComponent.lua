module("THSTG.SCENE", package.seeall)

local display = display
--在lua中对CC组件进行再封装是为了与UI组件创建方法的统一，方便UI编辑器配置的编写

--CCNode组件
function newNode(params)
	params = params or {}
	local node = cc.Node:create()
	node:setPosition(params.x or 0, params.y or 0)
	node:setContentSize(cc.size(params.width or 0, params.height or 0))
	if params.anchorPoint then
		node:setAnchorPoint(params.anchorPoint)
	end
	return node
end

--CCSprite组件
function newSprite(params)
	params = params or {}
	assert(type(params) == "table", "[Scene] newSprite() invalid params")

	-- local src = params.src or ""--ResManager.getEmptyImg()
	local sp = display.newSprite(src)
	if params.anchorPoint then
		sp:setAnchorPoint(params.anchorPoint)
	end
	if params.x or params.y then
		sp:setPosition(params.x or 0, params.y or 0)
	end
	local size = sp:getContentSize()
	if params.width then
		sp:setScaleX(params.width / size.width)
		--print(168, params.width, size.width)
	end
	if params.height then
		sp:setScaleY(params.height / size.height)
		--print(168, params.height, size.height)
	end
	if params.rect then
		sp:setTextureRect(params.rect)
	end

	function sp:setRect(rect)
		sp:setTextureRect(rect)
	end
	function sp:setSource(src)
		sp:setTexture(src)
	end
	function sp:clone()
		local cloneSpr = cc.Sprite:createWithTexture(self:getTexture())
		cloneSpr:setAnchorPoint(self:getAnchorPoint())
		cloneSpr:setScaleX(self:getScaleX())
		cloneSpr:setScaleY(self:getScaleY())
		return cloneSpr
	end

	if params.opacity then
		sp:setOpacity(params.opacity)
	end
	if params.scale then
		sp:setScale(params.scale)
	end

	if __PRINT_NODE_TRACK__ then
		local info = getTraceback()
		THSTG.NodeUtil.setClick(sp, function ()
			print(__PRINT_TYPE__, info)
		end, false)
	end

	return sp
end

--创建精灵帧
function newSpriteFrame(params)
	params = params or {}
	local src = params.src or ""--ResManager.getEmptyImg()
	return display.newSpriteFrame(params.src,params.rect)
end


--创建精灵帧数组
function newFrames(params)
	params = params or {}
	params.begin = params.begin or 1
	params.isReversed = params.isReversed or false

	return display.newFrames(params.pattern, params.begin, params.length, params.isReversed)
end

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

	local texture,texRect = loadTexture(source)
	
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

--水平切割
function newHFrames(params)
	return createHVFrames(params, false)
end
--竖直切割
function newVFrames(params)
	return createHVFrames(params, true)
end

--[[
--新建动画

]]
function newAnimation(params)
	params = params or {}

	local frames 
	if ( type(params.frames) == "table" ) then
		if(params.frames.pattern) then
			frames = newFrames(params.frames)
		elseif params.frames.source then
			frames = newHVFrames(params.frames)
		else
			frames = params.frames
		end
	else
		error("newAnimation() - invalid params:frames")
	end
	local time = params.time or (1/(#frames or 1))
	local animation,sprite = display.newAnimation(frames,time)

	if params.father then
		--TODO:停止
		params.father:playAnimationForever(animation)
	end

	return animation,sprite
end

function newAnimationSprite(params)
	params = params or {}
	params.father = nil

	local sprite = newSprite(params)
	local animation = newAnimation(params)

	if sprite and animation then
		
		sprite:playAnimationForever(animation)
	end

	return sprite
end
--------------------------------------------
--CCLayer组件
function newLayer(params)
	params = params or {}
	local node = cc.Layer:create()
	node:setPosition(cc.p(params.x or 0, params.y or 0))
	node:setContentSize(cc.size(params.width or 0, params.height or 0))
	if params.anchorPoint then
		node:setAnchorPoint(params.anchorPoint)
	end
	return node
end

--CC
--手势组件
--[[
	x				[number]		x
	y				[number]		y
	width			[number]		width
	height			[number]		height

	showColor		[bool]			是否显示颜色-方便确认位置

	slideLeft 		[function] 		向左滑动回调
	slideRight		[function]		向右滑动回调
	slideUp			[function]		向上滑动回调
	slideDown		[function]		向下滑动回调
--]]
function newLayerGesture(params)
	--参数初始化
	params = params or {}
	params.x = params.x or 0
	params.y = params.y or 0
	params.width = params.width or 100
	params.height = params.height or 100

	--根节点
	params.color = params.showColor and THSTG.UI.htmlColor2C4b("#00000088") or THSTG.UI.htmlColor2C4b("#00000000")
	local layer = newLayerColor(params)
	layer:setPosition(params.x, params.y)
	if params.anchorPoint then
		layer:setAnchorPoint(params.anchorPoint)
	end

	--触摸处理
	local p = cc.p(0, 0)
	local isHanderAction = false
	local function onTouchBegan(pTouch, event)
		local p0 = layer:convertToWorldSpace(cc.p(0, 0))
		local x, y = pTouch:getLocation().x, pTouch:getLocation().y

		if 0 <= (x - p0.x) and (x - p0.x) < params.width and
			0 <= (y - p0.y) and (y - p0.y) < params.height then
			p.x, p.y = x, y
			isHanderAction = false
			return true
		end
		return false
	end
	local function onTouchMoved(pTouch, event)
		if not isHanderAction then
			local x, y = pTouch:getLocation().x, pTouch:getLocation().y
			if (x - p.x) * (x - p.x) + (y - p.y) * (y - p.y) >= (params.sensitivity or 625) then
				isHanderAction = true
			else
				p.x, p.y = x, y
			end
		end
	end
	local function onTouchEnded(pTouch, event)
		if isHanderAction then
			local x, y = pTouch:getLocation().x, pTouch:getLocation().y
			if math.abs(x - p.x) > math.abs(y - p.y) then
				if x > p.x then
					if params.slideRight then
						params.slideRight()	--向右滑动手势
					end
				else
					if params.slideLeft then
						params.slideLeft()	--向左滑动手势
					end
				end
			else
				if y > p.y then
					if params.slideUp then
						params.slideUp()	--向上滑动手势
					end
				else
					if params.slideDown then
						params.slideDown()	--向下滑动手势
					end
				end
			end
		end
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	local dispatcher = layer:getEventDispatcher()
	dispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

	return layer
end

--CCLayerColor组件
function newLayerColor(params)
	params = params or {}
	assert(type(params) == "table", "[UI] newLayerColor() invalid params")

	local color = params.color or {}

	local r = color.r or 0
	local g = color.g or 0
	local b = color.b or 0
	local a = color.a or 255
	if type(params.opacity) == "number" then
		a = params.opacity * a
	end
	local width = params.width or display.width
	local height = params.height or display.height

	local node = cc.LayerColor:create(cc.c4b(r, g, b, a), width, height)
	if params.anchorPoint then
		node:setAnchorPoint(params.anchorPoint)
	end
	node:setPosition(params.x or 0, params.y or 0)
	return node
end

--CCScene组件
function newScene()
	return cc.Scene:create()
end

--[[ClippingNode
]]
function newClippingNode(params)
	params = params or {}

	local node = cc.ClippingNode:create()

	node:setPosition(cc.p(params.x or 0, params.y or 0))
	if params.anchorPoint then
		node:setAnchorPoint(params.anchorPoint)
	end
	if tolua.cast(params.stencil, "cc.Node") then
		node:setStencil(params.stencil)
	end
	if params.isInverted then
		node:setInverted(true)
	end
	return node
end

--[[ClippingRectangleNode
--params rect [cc.rect]
]]
function newClippingRectangleNode(params)
	params = params or {}

	local node = cc.ClippingRectangleNode:create()

	node:setPosition(cc.p(params.x or 0, params.y or 0))
	if params.anchorPoint then
		node:setAnchorPoint(params.anchorPoint)
	end
	if params.rect then
		node:setClippingRegion(params.rect)
	end

	return node
end

--[[
params rectData [cc.rect] 
params circleData [{cx, r}] 
]]

function newClippingNodeWithRegion(params)
	params = params or {}

	local stencil = cc.DrawNode:create()
	for i, v in ipairs(params.rectData or {}) do
		stencil:drawSolidRect(cc.p(v.x, v.y), cc.p(v.x + v.width, v.y + v.height), cc.c4f(0, 0, 0, 255))
	end
	for i, v in ipairs(params.circleData or {}) do
		stencil:drawSolidCircle(v.cx, v.r, 360, 1000, 1, 1, cc.c4f(0, 0, 0, 255))
	end
	params.stencil = stencil
	params.isInverted = true
	return newClippingNode(params)
end
function newTouchLayer(params)
	--参数初始化
	params = params or {}
	params.x = params.x or 0
	params.y = params.y or 0
	params.width = params.width or 100
	params.height = params.height or 100

	--根节点
	-- params.color = params.showColor and THSTG.UI.htmlColor2C4b("#00000088") or THSTG.UI.htmlColor2C4b("#00000000")
	local layer = THSTG.UI.newLayerColor(params)
	layer:setPosition(params.x, params.y)
	if params.anchorPoint then
		layer:setAnchorPoint(params.anchorPoint)
	end


	local function onTouchBegan(pTouch, event)
		local p0 = layer:convertToWorldSpace(cc.p(0, 0))
		local x, y = pTouch:getLocation().x, pTouch:getLocation().y

		if 0 <= (x - p0.x) and (x - p0.x) < params.width and
			0 <= (y - p0.y) and (y - p0.y) < params.height then
			local p = {}
			p.x, p.y = x, y

			if type(params.onTouch) == "function" then
				params.onTouch(p, "began")
			end
			return true
		end
		return false
	end
	local function onTouchMoved(pTouch, event)
		local p0 = layer:convertToWorldSpace(cc.p(0, 0))
		local x, y = pTouch:getLocation().x, pTouch:getLocation().y

		if 0 <= (x - p0.x) and (x - p0.x) < params.width and
			0 <= (y - p0.y) and (y - p0.y) < params.height then
			local p = {}
			p.x, p.y = x, y
			if type(params.onTouch) == "function" then
				params.onTouch(p, "moved")
			end

		end
	end
	local function onTouchEnded(pTouch, event)
		local p0 = layer:convertToWorldSpace(cc.p(0, 0))
		local x, y = pTouch:getLocation().x, pTouch:getLocation().y

		if 0 <= (x - p0.x) and (x - p0.x) < params.width and
			0 <= (y - p0.y) and (y - p0.y) < params.height then
			local p = {}
			p.x, p.y = x, y
			if type(params.onTouch) == "function" then
				params.onTouch(p, "ended")
			end

		end
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	local dispatcher = layer:getEventDispatcher()
	dispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

	return layer
end

function loadPlistFrames(params)
	params = params or {}

	if params.data then
		if params.img then
			display.loadSpriteFrames(params.data, params.img, params.onCallback)
		else
			cc.SpriteFrameCache:getInstance():addSpriteFrames(params.data)
		end
	end

end

function removePlistFrames(params)
	params = params or {}

	display.removeSpriteFrames(params.data, params.img)
end

--
function loadTexture(source)
	local texture = nil
	local texRect = nil

	if type(source) == "string" then
		if string.byte(source) == 35 then -- 第一个字符是 #
			--因为plist使用的纹理是一张大图,所以需要取得精灵
			local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(string.sub(source, 2))    
			if spriteFrame then
				texRect = spriteFrame:getRect()
				texture = spriteFrame:getTexture()
			else
				error(string.format("loadTexture() - invalid frame name \"%s\"", tostring(source)), 0)
				return nil,nil
			end
		else
			texture = display.loadImage(source)
			local textureSize = texture:getContentSize()
			texRect = cc.rect(0,0,textureSize.width,textureSize.height)
		end

	elseif tolua.type(source) == "cc.SpriteFrame" then
		texRect = source:getRect()
		texture = source:getTexture()

	elseif tolua.type(source) == "cc.Texture2D" then
		texture = source
		local textureSize = texture:getContentSize()
		texRect = cc.rect(0,0,textureSize.width,textureSize.height)

	else
		error("createFrame() - invalid parameters", 0)
	end

	return texture,texRect
end

function removeTexture(scource)
	if type(source) == "string" then
		if string.byte(source) == 35 then 
			display.removeSpriteFrame(source)
		else
			display.removeImage(source)
		end

	elseif tolua.type(source) == "cc.SpriteFrame" then
		display.removeSpriteFrame(source)

	elseif tolua.type(source) == "cc.Texture2D" then
		cc.SpriteFrameCache:getInstance():removeSpriteFramesFromTexture(source)

	elseif scource == nil then
		cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	else
		error("createFrame() - invalid parameters", 0)
	end

end