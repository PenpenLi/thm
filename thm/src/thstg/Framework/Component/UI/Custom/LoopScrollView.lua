-- 水平方向上循环
-- 而且没测过很多情况，可能存在很多bug,慎用
local M = ccclass("loopScrollView", cc.layout)

function M:ctor(params)
	self:setContentSize(params.width or 0,params.height or 0)
	self:setPosition(params.x or 0,params.y or 0)
	self:setListener()

	self.tileList = {}
	self.itemTemplate = params.itemTemplate
	
	self.itemWidth = params.itemWidth or 0
	self.itemHeight = params.itemHeight or 0

	self:initTile(params.offsetX)
	self.tileAmount = 0

	self.dataProvider = {}
	self:setDataProvider(params.dataProvider)

	local function enterExitSceneHandler(name)
		if name == "enter" then
			self:_onEnterScene()
		elseif name == "exit" then
			self:_onExitScene()
		elseif name == "cleanup" then
			self:_onDestroy()
		end
	end
	self:registerScriptHandler(enterExitSceneHandler)
end

function M:stopUpdateScheduler()
	if self.updateScheduler then
		Scheduler.unschedule(self.updateScheduler)
		self.updateScheduler = false
	end
end

function M:_onEnterScene()
	-- body
end

function M:_onExitScene()
	self:stopUpdateScheduler()
end

function M:_onDestroy()
	-- body
end

function M:initTile()
	local tileNum = math.ceil(self:getContentSize().width/self.itemWidth)
	tileNum = tileNum+1
	self.tileNum = tileNum
	for index = 1,tileNum do
		local tile = self.itemTemplate()
		self:addChild(tile)
		tile:setPositionX((index-2)*self.itemWidth+self.itemWidth/2)
		tile:setPositionY(self.itemHeight/2)

		function tile:setDataIndex(dataIndex)
			tile.__dataIndex = dataIndex
		end
		function tile:getDataIndex()
			return tile.__dataIndex
		end

		self.tileList[index] = tile
	end

	self.maxX = self.itemWidth*(self.tileNum)-self.itemWidth/2
	self.minX = self:getContentSize().width-self.itemWidth*self.tileNum+self.itemWidth/2
	self.deltaResetX = self.itemWidth*(self.tileNum)
end

function M:getTile(index)
	return self.tileList[index]
end

function M:setTile(index,tileData)
	local tile = self:getTile(index)
	if not tile then return end
	tile:setState(tileData,index)
	tile:setDataIndex(index)
end

function M:setDataProvider(dataProvider)
	if not dataProvider then return end
	self.dataProvider = dataProvider

	for index,tileData in ipairs(self.dataProvider)do
		self:setTile(index,tileData)
	end
end

function M:isTouchInside(point)
	local x, y = point.x, point.y
	local mySize = self:getContentSize()
	return x >= 0 and x <= mySize.width and y >= 0 and y <= mySize.height
end

function M:setListener()
	local deltaX = 0
	local lastPos = cc.p(0,0)
	local function onTouchBegan(pTouch, event)
		local point = self:convertTouchToNodeSpace(pTouch)
		if self:isTouchInside(point) then
			deltaX = 0
			lastPos = point
			return true
		end
	end

	local director = cc.Director:getInstance()
	local function onTouchMoved(pTouch, event)
		local point = self:convertTouchToNodeSpace(pTouch)
		deltaX = point.x - lastPos.x
		lastPos = point
	end

	local deltaV = 0
	local function onTouchEnded(pTouch, event)
		local deltaT = director:getDeltaTime()
		deltaV = deltaX/deltaT
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	local dispatcher = self:getEventDispatcher()
	dispatcher:addEventListenerWithSceneGraphPriority(listener, self)

	-- 用作减速的加速度
	local a = 3000
	self.updateScheduler = Scheduler.schedule(function()
		if deltaX~=0 then
			self:setTileMove(deltaX)
			deltaX = 0
		elseif deltaV~=0 then
			local deltaT = director:getDeltaTime()
			self:setTileMove(deltaT*deltaV)

			if deltaV>0 then
				deltaV = math.max(deltaV - deltaT*a,0)
			else
				deltaV = math.min(deltaV + deltaT*a,0)
			end
		end
	end,0)
end

function M:setTileMove(deltaX)
	for index,tile in ipairs(self.tileList)do
		local x = tile:getPositionX()+deltaX
		if x > self.maxX then
			x = x - self.deltaResetX
			
			local myIndex = index + 1
			if myIndex>#self.tileList then
				myIndex = 1
			end
			
			local myDataIndex = self.tileList[myIndex]:getDataIndex()-1
			if myDataIndex<=0 then
				myDataIndex = #self.dataProvider
			end
			tile:setState(self.dataProvider[myDataIndex],myDataIndex)
			tile:setDataIndex(myDataIndex)

		elseif x < self.minX then
			x = x + self.deltaResetX

			local myIndex = index - 1
			if myIndex==0 then
				myIndex = #self.tileList
			end

			local myDataIndex = self.tileList[myIndex]:getDataIndex()+1
			if myDataIndex>#self.dataProvider then
				myDataIndex = 1
			end
			tile:setState(self.dataProvider[myDataIndex],myDataIndex)
			tile:setDataIndex(myDataIndex)
		end
		tile:setPositionX(x)
	end
end

return M