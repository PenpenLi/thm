module("SceneManager", package.seeall)


----------------
-- local _sceneStack = {}
-- local _stackTop = 0

-- local function length()
--     return _stackTop
-- end

-- local function isEmpty()
--     return length() <= 0
-- end
-- local function pop()
--     if isEmpty() then return nil end
--     local data = _sceneStack[_stackTop]
--     _sceneStack[_stackTop] = nil
--     _stackTop = _stackTop - 1

--     return data
-- end


-- local function top()
--     return _sceneStack[_stackTop]
-- end

-- local function remove(data)
--     for i = 1,length() do
--         if _sceneStack[i] == data then
--             table.remove( _sceneStack, i )
--             _stackTop = _stackTop - 1
--             return true
--         end
--     end
--     return false
-- end

-- --
-- function getCurScene()
--     return display.getRunningScene()
-- end

-- function getTopScene()
--     return top()
-- end

-- function replace(scene, transition, time, more)
--     display.run(scene, transition, time, more)
-- end

-- function push(scene, transition, time, more)
--     local curScene = getCurScene()
--     if curScene == scene then return end
--     _stackTop = _stackTop + 1
--     _sceneStack[_stackTop] = curScene
--     curScene:retain()

--     replace(scene, transition, time, more)
-- end

-- function pop(transition, time, more)
--     if isEmpty() then return end
--     local scene = pop()
--     scene:release()

--     replace(scene, transition, time, more)
-- end

-- function popToButtom(transition, time, more)
--     if isEmpty() then return end

--     local curNum = _stackTop
--     for i = curNum,2,-1 do
--         local scene = pop()
--         scene:release()
--     end
    
--     local scene = pop()
--     scene:release()
    

--     replace(scene, transition, time, more)
-- end


-- function clear()
--     while not isEmpty() do
--         local scene = pop()
--         scene:release()
--     end
-- end

---------------------
local _sceneInfo = {}
local _scenes = {}

local function __get(sceneType)
    local scene = _scenes[sceneType]
    assert(scene, string.format( "[SceneManager] Can not find the Scene[\"%s\"]!",sceneType))
    return scene
end

function getRunning()
    return THSTG.SCENE.getRunningScene()
end

function replace(sceneType, transition, time, more)
    local scene = __get(sceneType)
    return THSTG.SCENE.replaceScene(scene, transition, time, more)
end

function push(sceneType, transition, time, more)
    local scene = __get(sceneType)
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
	table.insert(_sceneInfo, {sceneType = sceneType,classPath = classPath} )
end

function get(sceneType)
	return _scenes[sceneType]
end

function init()
    local firstScene = display.newScene()
    for i = #_sceneInfo,1,-1 do
        local classPath = _sceneInfo[i].classPath
        local sceneType = _sceneInfo[i].sceneType
		local Class = require(classPath)
        _scenes[sceneType] = Class.new()
        firstScene = _scenes[sceneType]
    end 

    display.runScene(firstScene)    --第一个场景或默认场景
end

function clear()
    for _,v in pairs(_scenes) do
		v:removeAllChildren()
	end  
end
---
