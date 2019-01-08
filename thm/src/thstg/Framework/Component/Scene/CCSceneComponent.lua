module("SCENE", package.seeall)

--CCScene组件
function newScene()
	return cc.Scene:create()
end

--精灵
--CCSprite组件
function newSprite(params)
	return UI.newSprite(params)
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
	params.length = params.length or 0
	params.isReversed = params.isReversed or false

	return display.newFrames(params.pattern, params.begin, params.length, params.isReversed)
end

-- 新建动画
-- @param	tiem			[number]	所需时间
-- @param	frames			[table]		帧动画精灵
function newAnimation(params)
	params = params or {}

	local frames = params.frames or {}
	local time = params.time or (1/(#frames or 1))
	local animation,_ = display.newAnimation(frames,time)

	return animation
end


----

--替换场景,释放当前场景
function replaceScene(myScene, transition, time, more)
	return display.runScene(myScene, transition, time, more)
end

function pushScene(myScene, transition, time, more)
	if transition then
		myScene = display.wrapScene(myScene, transition, time, more)
	end
	return cc.Director:getInstance():pushScene(myScene)
end

function popScene()
	return cc.Director:getInstance():popScene()
end

function getRunningScene()
	return cc.Director:getInstance():getRunningScene()
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


function loadPlistFile(path)
	return loadPlistFrames({data = path})
end

function removePlistFile(path)
	return removePlistFrames({data = path})
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