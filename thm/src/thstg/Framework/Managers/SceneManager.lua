module("SceneManager", package.seeall)

---------------------
local _firstSceneType = nil
local _sceneMap = {}
local _scenes = {}      --正在运行的场景

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

function replace(sceneType, transition, time, more)
    local scene = get(sceneType)
    return THSTG.SCENE.replaceScene(scene, transition, time, more)
end

function push(sceneType, transition, time, more)
    local scene =  get(sceneType)
    return THSTG.SCENE.pushScene(scene, transition, time, more)
end

function pop()
    return THSTG.SCENE.popScene()
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
    display.runScene(firstScene)    --第一个场景或默认场景
end

function clear()
    for _,v in pairs(_scenes) do
		v:removeAllChildren()
	end  
end
---
