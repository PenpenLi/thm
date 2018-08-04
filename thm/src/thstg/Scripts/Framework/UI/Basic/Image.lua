module("THSTG.UI", package.seeall)

-- IMAGE_DEFAULT_FILE = ResManager.getUIRes(UIType.IMAGE, "default")

--[[
@param style {
				src					[string]		图片资源相对路径
				scale9Rect
				resType				[number] 		资源类型，默认值为ccui.TextureResType.localType, 值为ccui.TextureResType = 
}															{
																	    localType = 0, 
																	    plistType = 1, 
}
@param  width                   [Number]        图片显示宽
@param  height                  [Number]        图片显示高, 设置width, height属性将会影响图片的显示，如果												
												width和height都不为零则把原图缩放至width和height的尺寸，
												如果width为nil，height不为零或width不为零，height为nil，则按
												原图比例缩放, 如果都为nil，显示原图
@param  x                       [Number]        x坐标
@param  y                       [Number]        y坐标
@param	onTouch					[function]		点击回调函数(按钮上执行的各种事件)，参数参考UI.Widget.lua
@param	onClick					[function]		点击回调函数(在按钮上按下并且松开)， 参数参考UI.Widget.lua
@param  onDoubleClick           [function]		双击回调函数
@param	anchorPoint				[cc.p]		 	锚点(如UI.POINT_LEFT_BOTTOM)
example:                                                
]]--

function newImage(params)
	params = params or {}
	assert(type(params) == "table", "[UI] newImage() invalid params")

	local function tipLog(str)
		-- print("newImage: "..str)
	end
	local lastClickTime = 0
	local finalParams = {
		source = "",
		x = 0, y = 0,
		width = nil, height = nil,
		anchorPoint = clone(POINT_CENTER),
		onClick = function ()
		-- body
		end,
		onTouch = function ()
		-- body
		end,
		onDoubleClick = function (...)
		-- body
		end,
		resType = ccui.TextureResType.localType,
		scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
	}
	THSTG.TableUtil.mergeA2B(params, finalParams)
	finalParams.width = params.width
	finalParams.height = params.height
	if params.style then
		finalParams.source = params.style.src or finalParams.source
		finalParams.resType = params.style.resType or finalParams.resType
		finalParams.scale9Rect = params.style.scale9Rect or finalParams.scale9Rect
	end

	local image = ccui.ImageView:create()
	local privateData = {}
	privateData.imageReady = false
	privateData.hasFile = true
	------------------------------------------------------------------------------
	function privateData.init()
		image:loadTexture(finalParams.source, finalParams.resType)
		image:setAnchorPoint(finalParams.anchorPoint)
		image:setPosition(cc.p(finalParams.x, finalParams.y))
		image:ignoreContentAdaptWithSize(false)
		if params.onTouch or params.onClick or params.onDoubleClick then
			image:setTouchEnabled(true)
			image:onTouch(privateData.onTouch)
		end
	end

	privateData.setContentSize = image.setContentSize

	function privateData.updateSize()
		local imageSize = image:getContentSize()
		local targetWidth = imageSize.width
		local targetHeight = imageSize.height
		if finalParams.width and finalParams.height then
			targetWidth = finalParams.width
			targetHeight = finalParams.height
		elseif finalParams.width then
			local rate = imageSize.width / imageSize.height
			targetWidth = finalParams.width
			targetHeight = (finalParams.width / rate)
		elseif finalParams.height then
			local rate = imageSize.width / imageSize.height
			targetWidth = finalParams.height * rate
			targetHeight = finalParams.height
		end
		privateData.setContentSize(image, cc.size(targetWidth, targetHeight))
		tipLog("imageW: "..tostring(imageSize.width).." imageH: "..tostring(imageSize.height))
	end
	function privateData.onTouch(event)
		if finalParams.onClick then
			if event.name == "ended" then
				finalParams.onClick(event.target)
				local curTime = millisecondNow()
				if curTime - lastClickTime < 260 then
					finalParams.onDoubleClick(event.target)
					lastClickTime = 0
				else
					lastClickTime = curTime
				end
				printStack(finalParams.onClick)
			end
		end

		if finalParams.onTouch then
			finalParams.onTouch(event)
		end
		tipLog("image onTouch")
	end

	local _testGoneTime = 0
	function privateData.update(dt)
		if privateData.imageReady  then
			_testGoneTime = _testGoneTime + dt
			if _testGoneTime >= 1 then
				_testGoneTime = 0
				local path = cc.FileUtils:getInstance():fullPathForFilename(finalParams.source)
				if #path ~= 0 and path ~= finalParams.source then
					privateData.imageReady = false
					image:loadTexture(finalParams.source, finalParams.resType)
					tipLog("successfully loaded.")
				else

				end
			end

		end
	end
	function privateData.freshViewCallBack(params)
		if params then
			for k, v in pairs(params) do
				print(k, v)
			end
			if params.status == 200 then
				privateData.imageReady = true
				tipLog("imageReady....")
			end
		end
	end

	function privateData.processCallBack(params)

	end
	-------------------------------------------------------------------------------
	--外部接口
	--[[重写loadText]]
	privateData.loadTexture = image.loadTexture
	function image:loadTexture(filename, resType)
		if type(filename) ~= "string" then
			return
		end
		if resType then
			finalParams.resType = resType
		end
		finalParams.source = filename

		local hasFile = true
		local absolutePath = string.sub(filename, 1, 1) == "/"

		local file = finalParams.source
		privateData.hasFile = hasFile
		privateData.loadTexture(self, file, finalParams.resType)
		if params.style and params.style.scale9Rect and privateData.hasFile then
			image:setScale9Enabled(true)
			--默认
			local skinSize = getSkinSize(file)
			local insetRectX = math.min(skinSize.width, finalParams.scale9Rect.left)
			local insetRectY = math.min(skinSize.height, finalParams.scale9Rect.top)
			local insetRectW = math.max(0, skinSize.width - insetRectX - finalParams.scale9Rect.right)
			local insetRectH = math.max(0, skinSize.height - insetRectY - finalParams.scale9Rect.bottom)
			image:setCapInsets(cc.rect(insetRectX, insetRectY, insetRectW, insetRectH))
		end
		privateData.updateSize()
	end

	function image:setSource(filename, resType)
		-- printTraceback()
		-- dump(5, filename, "filename")
		image:loadTexture(filename, resType)
	end

	function image:setTexture(filename, resType)
		image:loadTexture(filename, resType)
	end
	--[[设置大小]]
	function image:setSize(width, height)
		finalParams.width = width
		finalParams.height = height
		privateData.updateSize()
	end

	function image:setContentSize(size)
		finalParams.width = size.width
		finalParams.height = size.height
		privateData.updateSize()
	end

	function image:onClick(func, swallow)
		if swallow == nil then
			swallow = true
		end
		local function onTouch(params)
			if params.name == "ended" then
				func(image)
			end
		end
		image:setTouchEnabled(true)
		image:onTouch(onTouch)
		image:setSwallowTouches(swallow)
	end

	function image:getClick()
		return finalParams.onClick
	end

	if __PRINT_TRACK__ then
		-- local info = getTraceback()
		-- if params.onClick then
		-- else
		-- 	image:onClick(function ()
		-- 		print(__PRINT_TYPE__, info)
		-- 		if params.mornFile then
		-- 			print(__PRINT_TYPE__, "mornFile - ", params.mornFile)
		-- 		end
		-- 		if params.mornName then
		-- 			print(__PRINT_TYPE__, "mornName - ", params.mornName)
		-- 		end
		-- 	end, false)
		-- end
	end

	----------------------------------------------------------------
	privateData.init()
	return image
end

--[[

@param  width                   [Number]        图片显示宽, 纵向时，宽度等于原图宽度
@param  height                  [Number]        图片显示高， 横向时，高度等于原图高度
@param  direction               [number]        可滚动方向，取值[ccui.ScrollViewDir]，默认ccui.ScrollViewDir.horizontal 
@param  style = {
					bgColor = COLOR_BLACK, 背景
					src					[string]		图片资源相对路径
					resType					[number] 		资源类型，默认值为ccui.TextureResType.localType, 值为ccui.TextureResType = 
																	{
																	    localType = 0, 
																	    plistType = 1, 
}
}					
@param  x                       [Number]        x坐标
@param  y                       [Number]        y坐标
@param	onTouch					[function]		点击回调函数(按钮上执行的各种事件)，参数参考UI.Widget.lua
@param	onClick					[function]		点击回调函数(在按钮上按下并且松开)， 参数参考UI.Widget.lua
@param	anchorPoint				[cc.p]		 	锚点(如UI.POINT_LEFT_BOTTOM)
example:                                                
  ]]--
function newScrollImage(params)
	assert(type(params) == "table", "[UI] newScrollImage() invalid params")

	local function tipLog(str)
		print("newScrollImage: "..str)
	end

	local finalParams = {

			x = 0, y = 0,
			width = nil, height = nil,
			anchorPoint = clone(POINT_CENTER),
			onClick = function ()
			-- body
			end,
			onTouch = function ()
			-- body
			end,
			direction = ccui.ScrollViewDir.horizontal,

			style = {
				bgColor = COLOR_BLACK,
				src = "",
				resType = ccui.TextureResType.localType,
			}
	}
	TableUtil.mergeA2B(params, finalParams)
	finalParams.width = params.width
	finalParams.height = params.height

	local scrollImage = nil
	local image = newImage({
		x = 0, y = 0,
		width = nil, height = nil,
		anchorPoint = clone(POINT_LEFT_BOTTOM),
		onClick = finalParams.onClick,
		onTouch = finalParams.onTouch,
		style = finalParams.style,
	})

	local imageSize = image:getContentSize()
	tipLog("fwi: "..tostring(params.width))
	finalParams.width = finalParams.width or imageSize.width
	finalParams.height = finalParams.height or imageSize.height
	if finalParams.direction == ccui.ScrollViewDir.horizontal then
		finalParams.height = imageSize.height
	elseif finalParams.direction == ccui.ScrollViewDir.vertical then
		finalParams.width = imageSize.width
	else

	end

	scrollImage = newScrollView({
		x = finalParams.x, y = finalParams.y,
		width = finalParams.width, height = finalParams.height,
		innerWidth = imageSize.width, innerHeight = imageSize.height,
		bounceEnabled = false,
		anchorPoint = finalParams.anchorPoint,
		direction = finalParams.direction,
		style = finalParams.style
	})
	tipLog("fw: "..tostring(finalParams.width).." fh: "..tostring(finalParams.height).." iw: "..tostring(imageSize.width).." ih: "..tostring(imageSize.height))
	scrollImage:addChild(image)
	return scrollImage
end
