module("SceneManager", package.seeall)

---------------------
local _firstSceneType = nil
local _sceneMap = {}
local _scenes = {}      --正在运行的场景
local _curScene = nil

local function __getClass(sceneType)
    return _sceneMap[sceneType]
end

local function __getScene(sceneType)
    local scene = _scenes[sceneType]
    if scene and tolua.isnull(scene) then
        print("[SceneManager] Warning,the scene has already been released!")
        _scenes[sceneType] = nil
        return nil
    end
    return scene
end

local function __createScene(sceneType)
    local classPath = __getClass(sceneType)
    assert(classPath, string.format( "[SceneManager] Can not find the Scene[\"%s\"]!",sceneType))
    local scene = require(classPath).new()
    _scenes[sceneType] = scene
    return scene
end

function get(sceneType)
    local scene = __getScene(sceneType) or __createScene(sceneType)
    return scene
end
---

function getRunning()
    return THSTG.SCENE.getRunningScene()
end

function getCurScene()
    return _curScene
end

function replace(sceneType, transition, time, more)
    _curScene = get(sceneType)
    Dispatcher.dispatchEvent(EVENT_TYPE.SCENEMGR_REPLACE, sceneType)
    Dispatcher.dispatchEvent(EVENT_TYPE.SCENEMGR_CHANGED, _curScene)
    return THSTG.SCENE.replaceScene(_curScene, transition, time, more)
end

function push(sceneType, transition, time, more)
    _curScene = get(sceneType)
    Dispatcher.dispatchEvent(EVENT_TYPE.SCENEMGR_PUSH, sceneType)
    Dispatcher.dispatchEvent(EVENT_TYPE.SCENEMGR_CHANGED, _curScene)
    return THSTG.SCENE.pushScene(_curScene, transition, time, more)
end

function pop()
    Dispatcher.dispatchEvent(EVENT_TYPE.SCENEMGR_POP)
    THSTG.SCENE.popScene()
    _curScene = getRunning()
    Dispatcher.dispatchEvent(EVENT_TYPE.SCENEMGR_CHANGED, _curScene)
end

local function initRun(scene)
    display.runScene(scene)    --第一个场景或默认场景
    _curScene = scene
    Dispatcher.dispatchEvent(EVENT_TYPE.SCENEMGR_CHANGED, _curScene)
end

function run(sceneType)
    return replace(sceneType)
end
-----
function register(sceneType, classPath)
    local info =  {sceneType = sceneType,classPath = classPath} 
    _sceneMap[sceneType] = classPath
    _firstSceneType = _firstSceneType or sceneType
end

function init()
    local firstScene = _firstSceneType and get(_firstSceneType) or display.newScene()
    initRun(firstScene)
end

function clear()
    for _,v in pairs(_scenes) do
		v:removeAllChildren()
	end  
end
---
