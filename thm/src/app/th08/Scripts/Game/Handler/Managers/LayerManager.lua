module("LayerManager", package.seeall)

local scene = false

--窗口
DEPTH_WINDOW_LAYER = 2
--主界面UI
DEPTH_MAIN_UI_LAYER = 3

------------
-- 平行摄像机对象
orthographicCamera = false

---------
--持久UI层
endureUILayer = false
--界面UI
mainUILayer = false
--界面UI
guiLayer = false
--提示层
tipLayer = false
--窗口
windowLayer = false
--置顶层
stickLayer = false
--保留层：不被init所初始化，登录
saveLayer = false

-------
local function s_setupCamera(scene, cameraMask)
	local camera = cc.Camera:create()
	camera:initDefault()
	camera:setCameraFlag(cameraMask)
	camera:setDepth(cameraMask)
	camera:setScene(scene)
	scene:addChild(camera)
	return camera
end

local function s_setupLayer(scene, cameraMask, posZ)
	local layer = cc.Layer:create()
	scene:addChild(layer)
	layer:setCameraMask(cameraMask, true)
	layer:setPositionZ(posZ or 0)
	return layer
end

function init()
	if saveLayer then
		saveLayer:retain()
		saveLayer:removeFromParent()
	end

	if not scene then
		scene = display.newScene()
		display.runScene(scene)
	else
		scene:removeAllChildren()
	end

	-- 摄像机
	orthographicCamera = s_setupCamera(scene, cc.CameraFlag.USER1)

	-- 普通层
	s_setupCamera(scene, cc.CameraFlag.USER3)

	endureUILayer = s_setupLayer(scene, cc.CameraFlag.USER3, 0) -- 最后
	mainUILayer = s_setupLayer(scene, cc.CameraFlag.USER3, 0) -- 最后
	guiLayer = s_setupLayer(scene, cc.CameraFlag.USER3, 0) -- 最后
	tipLayer = s_setupLayer(scene, cc.CameraFlag.USER3, 0) -- 最后
	windowLayer = s_setupLayer(scene, cc.CameraFlag.USER3, 0)
	stickLayer = s_setupLayer(scene, cc.CameraFlag.USER3, 0)
	

	if saveLayer then
		scene:addChild(saveLayer)
		saveLayer:setCameraMask(cc.CameraFlag.USER3, true)
		saveLayer:release()
	else
		saveLayer = s_setupLayer(scene, cc.CameraFlag.USER3)
	end

	-- if not __HIDE_TEST__ then
		
	-- end
end

function add2EndureUILayer(view)
	endureUILayer:addChild(view)
end

function add2MainUILayer(view)
	mainUILayer:addChild(view)
end

function add2GUILayer(view)
	guiLayer:addChild(view)
end

function add2TipLayer(view)
	tipLayer:addChild(view)
end

function add2WindowLayer(view)
	windowLayer:addChild(view)
end

function add2StickLayer(view)
	stickLayer:addChild(view)
end
