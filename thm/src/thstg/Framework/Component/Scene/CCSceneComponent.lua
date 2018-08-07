module("THSTG.SCENE", package.seeall)

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
	assert(type(params) == "table", "[UI] newSprite() invalid params")

	local src = params.src or ""--ResManager.getEmptyImg()
	local sp = cc.Sprite:create(src)
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
	if params.frame then
		sp:setTextureRect(params.frame)
	end

	function sp:setRect(frame)
		sp:setTextureRect(frame)
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
		THSTG.UI.setClick(sp, function ()
			print(__PRINT_TYPE__, info)
		end, false)
	end

	-- debugUI(sp)
	return sp
end

--CCScale9Sprite组件
function newScale9Sprite(params)
	params = clone(params)
	params = params or {}
	assert(type(params) == "table", "[UI] newScale9Sprite() invalid params")
	params.style = params.style or {}
	local scale9Rect = params.style.scale9Rect or {left = 0, top = 0, right = 0, bottom = 0}
	local src = params.style.src or ""--ResManager.getEmptyImg()

	--默认
	local skinSize = {}
	skinSize.width = params.style.width
	skinSize.height = params.style.height
	local textureSize = THSTG.UI.getSkinSize(src)
	if not skinSize.width or not skinSize.height then
		skinSize.width = skinSize.width or textureSize.width
		skinSize.height = skinSize.height or textureSize.height
	end

	local insetRectX = math.min(textureSize.width, scale9Rect.left)
	local insetRectY = math.min(textureSize.height, scale9Rect.top)
	local insetRectW = math.max(0, textureSize.width - insetRectX - scale9Rect.right)
	local insetRectH = math.max(0, textureSize.height - insetRectY - scale9Rect.bottom)

	local rect = cc.rect(0, 0, 0, 0)
	TableUtil.mergeA2B(params.rect, rect)

	local frameRect = cc.rect(0 + rect.x, 0 + rect.y, skinSize.width + rect.width, skinSize.height + rect.height)
	local scaleRect = cc.rect(insetRectX, insetRectY, insetRectW, insetRectH)
	local node = ccui.Scale9Sprite:create(src, frameRect, scaleRect)

	node:setPosition(params.x or 0, params.y or 0)
	if params.anchorPoint then
		node:setAnchorPoint(params.anchorPoint)
	end
	skinSize.width = params.width or skinSize.width
	skinSize.height = params.height or skinSize.height
	node:setContentSize(skinSize)

	node:setInvert(params.invert or false)

	if __PRINT_NODE_TRACK__ then
		local info = getTraceback()
		THSTG.UI.setClick(node, function ()
			print(__PRINT_TYPE__, info)
		end, false)
	end

	-- debugUI(node)
	return node
end

function newQuickScale9Sprite(src,scaleRect)
	local tmpSkin, skinSize, insetRectX, insetRectY, insetRectW, insetRectH
	
	local scaleGridRect = scaleRect or {left=0, top=0, right=0, bottom=0}
	--默认
	local skinSize = THSTG.UI.getSkinSize(src)
	insetRectX = scaleGridRect.left
	insetRectY = scaleGridRect.top
	insetRectW = skinSize.width - insetRectX - scaleGridRect.right
	insetRectH = skinSize.height - insetRectY - scaleGridRect.bottom
	return ccui.Scale9Sprite:create(src, cc.rect(0,0,skinSize.width, skinSize.height), cc.rect(insetRectX, insetRectY, insetRectW, insetRectH))
end


function newSimpleScale9Sprite(src, scaleRect)
	local tmpSkin, skinSize, insetRectX, insetRectY, insetRectW, insetRectH

	local scaleGridRect = scaleRect or {left = 0, top = 0, right = 0, bottom = 0}
	--默认
	local skinSize = THSTG.UI.getSkinSize(src)
	insetRectX = scaleGridRect.left
	insetRectY = scaleGridRect.top
	insetRectW = skinSize.width - insetRectX - scaleGridRect.right
	insetRectH = skinSize.height - insetRectY - scaleGridRect.bottom
	return ccui.Scale9Sprite:create(src, cc.rect(0, 0, skinSize.width, skinSize.height), cc.rect(insetRectX, insetRectY, insetRectW, insetRectH))
end


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

-- --[[
-- --新建动画
-- --@param data 			[string] 		plist文件路径
-- --@param img 			[string] 		plist文件对应图片路径
-- --@param onCallback 	[function] 		回调函数
-- ]]
-- function newAnimation(params)
-- 	params = params or {}
-- 	local animation = nil
-- 	if( type(params.frames) == "userdata" ) then
-- 		animation = display.newAnimation(params.frames,params.time)
-- 	elseif ( type(params.frames) == "table" ) then
-- 		animation = display.newAnimation(params.pattern, params.begin, params.length, params.isReversed,params.time)
-- 	else
-- 		error("newAnimation() - invalid params:frames")
-- 	end

-- 	return animation
-- end

--[[
--加载Plist纹理
--@param data 			[string] 		plist文件路径
--@param img 			[string] 		plist文件对应图片路径
--@param onCallback 	[function] 		回调函数
]]
function loadPlist(params)
	params = params or {}

	if params.data then
		if params.img then
			display.loadSpriteFrames(params.data, params.img, params.onCallback)
		else
			cc.SpriteFrameCache:getInstance():addSpriteFrames(params.data)
		end
	end

end

function removePlist(params)
	params = params or {}

	display.removeSpriteFrames(params.data, params.img)
end


--
