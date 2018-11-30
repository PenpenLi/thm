module(..., package.seeall)

local M = {}

local createTemplate = function(title, w, h, zoomScale, outline, isDrawArrow, imageType, exData,callback)
	local btn = THSTG.UI.newWidget({
		width = w, height = h,
	})

	local isArrow = isDrawArrow or false
	local imageType = imageType or 1
	local imageNormalName = "Assets/UI/Window/win_frame8.png"
	local imageSelectedName = "Assets/UI/Window/win_frame8.png"
	if 2 == imageType then
		imageNormalName = "Assets/UI/Window/win_frame3.png"
		imageSelectedName = "Assets/UI/Window/win_frame_high_3.png"
	elseif 3 == imageType then
		imageNormalName = "Assets/UI/Window/win_frame11.png"
		imageSelectedName = "Assets/UI/Window/win_frame11.png"
	end

	local selectedBtn = THSTG.UI.newBaseButton({
		text = title,
		zoomScale = zoomScale,
		style = {
			normal = {
				label = {size = THSTG.UI.FONT_SIZE_NORMAL, color = THSTG.UI.getColorHtml("#15233d")},
				skin = {
					src = imageNormalName,--ResManager.getUIRes(UIType.WINDOW, imageNormalName),
					scale9Rect = {left = 20, right = 20, top = 20, bottom = 20},
				}
			},
			selected = {
				label = {size = THSTG.UI.FONT_SIZE_NORMAL, color = THSTG.UI.getColorHtml("#15233d")},
				skin = {
					src = imageSelectedName,--ResManager.getUIRes(UIType.WINDOW, imageSelectedName),
					scale9Rect = {left = 20, right = 20, top = 20, bottom = 20}
				}
			},
			disabled = {
				label = {size = THSTG.UI.FONT_SIZE_NORMAL, color = THSTG.UI.COLOR_GRAY_C, outline = outline or 1},
				skin = {
					src = imageNormalName,--ResManager.getUIRes(UIType.ACCORDION, "accord_disa1"),
					scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
				}
			}
		},
		width = w, height = h
	})
	selectedBtn:setSwallowTouches(false)
	selectedBtn:setPropagateTouchEvents(false)
	btn:addChild(selectedBtn)


	--箭头
	if isArrow then
		local arrow = THSTG.UI.newImage({
			source = nil,--ResManager.getRes(ResType.PUBLIC, "img_arrow"),
			x = w-15,
			y = h / 2,
			anchorPoint = THSTG.UI.POINT_RIGHT_CENTER
		})
		btn:addChild(arrow, 2, 2)
		arrow:setFlippedY(true)
	end

	if exData and exData.redDotData then
		local redDot = UIPublic.newRedDot(exData.redDotData)
		btn:addChild(redDot)
	end

	function btn:onChange(params)
		if params.isFolded then
			selectedBtn:setNormalNode()
			if isArrow then
				self:getChildByTag(2):setFlippedY(true)
			end
		else
			selectedBtn:setSelectedNode()
			if type(callback) == "function" then 
				callback(self)
			end
			if isArrow then
				self:getChildByTag(2):setFlippedY(false)
			end
		end
	end

	return btn
end

local function insertItem(accordion, width, title, position)
	local function newContent()
		local bg = display.newSprite(nil, 0, 0, {scale9 = true})
		bg:setContentSize(cc.size(width, 100))
		return bg
	end
	accordion:insertItem(createTemplate(tostring(title), width, THSTG.UI.ACCORDION_DEFAULT_HEAD_HEIGHT), newContent(), position)
end

--test
local function test(accordion, width)
	for i = 1, 50 do
		insertItem(accordion, width, "item"..tostring(i))
		--privateData.insertItem(ACCORDION_DEFAULT_HEAD_TEMPLATE("item"..tostring(i), finalParam.width, 40), ACCORDION_DEFAULT_HEAD_TEMPLATE("item"..tostring(i), finalParam.width, 100))
	end
end


function M.create(params)
    local layer = THSTG.UI.newLayer()

    local itemWidth = 200
	local accordion = THSTG.UI.newAccordion({
		x = display.cx, 
		y = display.cy,
		width = itemWidth,
		height = 400,
		anchorPoint = THSTG.UI.POINT_CENTER,
		gap = 4, --间隔
		onChange = function (node, curPosition, lastPosition)
			local curIsFolded = node:isFolded(curPosition)
			local lastIsFolded = true
			if lastPosition then
				lastIsFolded = node:isFolded(lastIsFolded)
				print("pos: "..tostring(lastPosition).." isFolded: "..tostring(lastIsFolded))
			end

			local len = math.random(0, 200)
			--and curPosition ~= node:getItemNum()
			if not curIsFolded and curPosition ~= 1 then
				node:setContentLen(curPosition, len)
				if curPosition == node:getItemNum() then
					insertItem(node, itemWidth, "insertEnd")
					print("insertItem toEnd: ")
				elseif curPosition == node:getItemNum() - 1 then
					node:deleteItem(curPosition)
					print("deleteItem: "..tostring(curPosition))
				elseif curPosition == node:getItemNum() - 2 then
					node:deleteItem(curPosition)
					print("deleteItem: "..tostring(curPosition))
				elseif curPosition == node:getItemNum() - 3 then
					insertItem(node, itemWidth, "insert"..tostring(curPosition), curPosition)
					print("insertItem topos: "..tostring(curPosition))
				end
			end

			print("pos: "..tostring(curPosition).." isFolded: "..tostring(curIsFolded).." len: "..tostring(len))
        end,
       
	})
	layer:addChild(accordion)
	
	test(accordion, itemWidth)
	--
	local sv1 = THSTG.UI.newScrollView({
		x = 0, y = 0,
		width = itemWidth, height = 150,
		innerWidth = 300, innerHeight = 300,
		anchorPoint = THSTG.UI.POINT_CENTER,
	})

	local lb = THSTG.UI.newLabel({
		text = "这是第一个文本",
		x = 10, y = 10
	})
	sv1:addChild(lb)
	--事件不往下传
	sv1:setPropagateTouchEvents(false)
	local lb = THSTG.UI.newLabel({
		text = "这是第二个文本",
		x = 10, y = 150,
		style = {color = THSTG.UI.COLOR_RED, size = 50}
	})
	sv1:addChild(lb)



	--插入一个View
	accordion:insertItem(createTemplate("ScrollViewItem", itemWidth, 40), sv1, 1)

    return layer
end
return M
