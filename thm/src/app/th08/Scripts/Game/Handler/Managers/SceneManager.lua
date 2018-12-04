module("SceneManager", package.seeall)

--菜单场景
menuScene = false
--舞台场景
stageScene = false
--测试场景
testScene = false




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

-- function replaceScene(scene, transition, time, more)
--     display.runScene(scene, transition, time, more)
-- end

-- function pushScene(scene, transition, time, more)
--     local curScene = getCurScene()
--     if curScene == scene then return end
--     _stackTop = _stackTop + 1
--     _sceneStack[_stackTop] = curScene
--     curScene:retain()

--     replaceScene(scene, transition, time, more)
-- end

-- function popScene(transition, time, more)
--     if isEmpty() then return end
--     local scene = pop()
--     scene:release()

--     replaceScene(scene, transition, time, more)
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
    

--     replaceScene(scene, transition, time, more)
-- end


-- function clear()
--     while not isEmpty() do
--         local scene = pop()
--         scene:release()
--     end
-- end

---------------------
function replaceScene(scene, transition, time, more)
    return THSTG.SCENE.replaceScene(scene, transition, time, more)
end

function pushScene(scene, transition, time, more)
    return THSTG.SCENE.pushScene(scene, transition, time, more)
end

function popScene()
    return THSTG.SCENE.popScene()
end

function init()
    menuScene = cc.Scene:create()
    stageScene = cc.Scene:create()
    testScene = cc.Scene:create()

end