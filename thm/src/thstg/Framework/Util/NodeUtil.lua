module("NodeUtil", package.seeall)

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




--3d坐标转局部坐标
function convertToNodeSpace3D(node)
    local mat = node:getNodeToWorldTransform()
    local x,y,z = node:getPositionX(),node:getPositionY(),node:getPositionZ()
    local rx = x*mat[1] + y*mat[2] + z*mat[3] +mat[4]
    local ry = x*mat[5] + y*mat[6] + z*mat[7] +mat[8]
    local rz = x*mat[9] + y*mat[10] + z*mat[11] +mat[12]
    return cc.vec3(rx,ry,rz)
end

--是否点中节点-对3d点存在测不准的bug,主要是检测矩形有问题
function isTouchInsideNode(node,pTouch)
    if not node or tolua.isnull(node) then
        return false
    end
    
    local nodePos = node:convertToWorldSpace(cc.p(0,0))
    local nodeSize = node:getContentSize()
    local touchPoint = cc.p(pTouch:getLocation().x, pTouch:getLocation().y)
    local anchorPoint = node:getAnchorPoint()
    --注:对于特效来说debugUI后其左下角坐标就是中心点,与anchorPoint无关
    --既anchorPoint为(0,0)时,nodePos即为特效中点
    local touchRect = cc.rect(
        nodePos.x - (anchorPoint.x) * nodeSize.width ,
        nodePos.y - (anchorPoint.y) * nodeSize.height ,
        nodeSize.width ,
        nodeSize.height
    )
    -- if node:getName() == "EffectNode" then
        --求出左下角的点,既特效中点,在做平移
        -- touchRect.x = touchRect.x - nodeSize.width/2
        -- touchRect.y = touchRect.y - nodeSize.height/2
    -- end

    if cc.rectContainsPoint(touchRect, touchPoint) then
        return true
    end
    return false
end

--挑出选中的节点,适用于3d节点
function pickTouchNode3D(nodes,pTouch)
    if type(nodes) == "userdata" then
        nodes = {nodes}
    end
    local ret = {}
    for _,v in ipairs(nodes) do
        if isTouchInsideNode(v,pTouch) then
            local info = {
                node = v,
                zOrder = convertToNodeSpace3D(v).z
            }
            ret[#ret + 1] = info
        end
    end
    table.sort(ret, function(a,b)
        return a.zOrder > b.zOrder--按Z轴排序
    end)

    local retNode = ret[1] and ret[1].node or nil
    return retNode
end

--[[
    为node设置触碰事件
    @onTouchBegan
    @onTouchMoved
    @onTouchEnded
]]
function addTouchListener(node,params)

    local function onTouchBegan(pTouch, event)
        if type(params.onTouchBegan) == "function" then
            if isTouchInsideNode(node,pTouch) then
                return params.onTouchBegan(pTouch, event)
            end
        end
        return true
    end
    local function onTouchMoved(pTouch, event)
        if type(params.onTouchMoved) == "function" then
            params.onTouchMoved(pTouch, event)
        end
	end
    local function onTouchEnded(pTouch, event)
        if type(params.onTouchEnded) == "function" then
            params.onTouchEnded(pTouch, event)
        end
    end
    

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = node:getEventDispatcher()
    eventDispatcher:removeEventListenersForTarget(node)
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, node)


    return listener
end


--为node添加点击监听
function addClickListener(node,params)
    if type(params) == "function" then
        params = {onClick = params}
    end

    return addTouchListener(node,{
        onTouchBegan = function (pTouch, event)
            return isTouchInsideNode(node,pTouch)
        end,

        onTouchEnded = function (pTouch, event)
            if type(params.onClick) == "function" then
                params.onClick(node)
            end
        end
    })
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