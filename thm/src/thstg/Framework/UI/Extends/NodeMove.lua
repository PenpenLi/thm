module("THSTG.UI", package.seeall)

-- 设置至中心
function makeMeCenter(node)
	if tolua.isnull(node) then
		return
	end

	local parent = node:getParent()
	if not parent then
		return
	end
	local size = parent:getContentSize()
	node:setPosition(cc.p(size.width / 2, size.height / 2))
end

-- 将一个节点放到一个box，根据box的锚点对齐
function makeMeInBox(node, box)
	-- 锚点根据box的锚点
	if not node then
		return
	end
	if not box then
		return
	end
	box:addChild(node)
	local anchorPoint = box:getAnchorPoint()
	node:setAnchorPoint(anchorPoint)
	local size = box:getContentSize()
	node:setPosition(cc.p(anchorPoint.x * size.width, anchorPoint.y * size.height))
end

-- 将一个节点放到一个box中间
function makeMeCenterInBox(node, box)
	-- 锚点根据box的锚点
	if not node then
		return
	end
	if not box then
		return
	end
	box:addChild(node)
	local size = box:getContentSize()
	node:setAnchorPoint(cc.p(0.5, 0.5))
	node:setPosition(cc.p(size.width/2, size.height/2))
end

----- 测试 点击 -----
function setClick(node, func, swallowTouches)

	local function onTouchBegan(touch, event)
		local locationInNode = node:convertToNodeSpace(touch:getLocation())
		local size = node:getContentSize()
		local rect = cc.rect(0, 0, size.width, size.height)
		if cc.rectContainsPoint(rect, locationInNode) then
			return true
		end
		return false
	end

	local function onTouchMoved(touch, event)

	end

	local function onTouchEnd(touch, event)
		local locationInNode = node:convertToNodeSpace(touch:getLocation())
		local size = node:getContentSize()
		local rect = cc.rect(0, 0, size.width, size.height)
		if cc.rectContainsPoint(rect, locationInNode) then
			func(node, touch)
		end
	end

	if func == nil then
		onTouchEnd = function () end
	end

	if swallowTouches == nil then
		swallowTouches = true
	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnd, cc.Handler.EVENT_TOUCH_ENDED)
	-- 屏蔽触摸向下传递
	listener:setSwallowTouches(swallowTouches)

	local eventDispatcher = node:getEventDispatcher()
	eventDispatcher:removeEventListenersForTarget(node)
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end


-- 测试移动用
function setMove(node, params)
	params = params or {}

	local prePos
	local curPos

	local function onTouchBegan(touch, event)
		local locationInNode = node:convertToNodeSpace(touch:getLocation())
		local size = node:getContentSize()
		local rect = cc.rect(0, 0, size.width, size.height)
		if cc.rectContainsPoint(rect, locationInNode) then
			prePos = touch:getLocation()
			return true
		end
		return false
	end

	local function onTouchMoved(touch, event)
		local locationInNode = node:convertToNodeSpace(touch:getLocation())

		curPos = touch:getLocation()
		local disX = curPos.x - prePos.x
		local disY = curPos.y - prePos.y
		prePos = curPos

		local posX = node:getPositionX()
		local posY = node:getPositionY()

		node:setPosition(ccp(posX+disX, posY+disY))
	end

	local function onTouchEnd(touch, event)

	end

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnd, cc.Handler.EVENT_TOUCH_ENDED)

	local swallowTouches = params.swallowTouches
	if swallowTouches == nil then
		swallowTouches = true
	end
	listener:setSwallowTouches(swallowTouches)

	local eventDispatcher = node:getEventDispatcher()
	eventDispatcher:removeEventListenersForTarget(node)
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)
end

-- widget才能用
function onMove(widget, params)
	params = params or {}

	local prePos
	local curPos
	local function onTouch(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			prePos = widget:getTouchBeganPosition()
		elseif eventType == ccui.TouchEventType.moved then
			curPos = widget:getTouchMovePosition()
			local disX = curPos.x - prePos.x
			local disY = curPos.y - prePos.y
			prePos = curPos
			local posX = widget:getPositionX()
			local posY = widget:getPositionY()
			widget:setPosition(ccp(posX+disX, posY+disY))

		elseif eventType == ccui.TouchEventType.ended then
			if params.onTouchEnded then
				params.onTouchEnded(sender)
			end
		end
	end

	local swallowTouches = params.swallowTouches
	if swallowTouches == nil then
		swallowTouches = true
	end

	widget:setTouchEnabled(true)
	widget:setSwallowTouches(swallowTouches)
	widget:addTouchEventListener(onTouch)
end
