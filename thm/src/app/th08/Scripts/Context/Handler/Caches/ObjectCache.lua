module("ObjectCache", package.seeall)

local objsCache = {}            --所有对象缓存的信息
local categoryCache = {}
---
local function getTotalObjs(class)
    local num = 0
    for _,v in pairs(objsCache) do
        if v.class == class then
            num = num + 1
        end
    end
    return num
end

local function getAvailableObjs(class)
    if not categoryCache[class] then return 0 end

    local queue = categoryCache[class]
    return (queue.tail - queue.front)
end
----
--自动扩充
function create(class,param)
    if type(class) == "table" then
        local queue = nil
        if not categoryCache[class] then
            --创建一个对象并返回
            queue = {front = 0,tail = 0,data = {}}
            categoryCache[class] = queue
        else
            queue = categoryCache[class]
        end
        --没有可用的对象,现场做一个
        if queue.front == queue.tail then
            
            --
            local obj = class.new(param)
            objsCache[obj] = {
                class = class,
                object = obj
            }

            if tolua.cast(obj,"cc.Node") then
                obj:retain()
            end

            --入队
            queue.tail = queue.tail + 1
            queue.data[queue.tail] = obj
            
        end
        
        --出队
        queue.front = queue.front + 1
        return queue.data[queue.front]

    end
    return nil
end

function release(obj,isDelete)
    local info = objsCache[obj]
    if info then
        local class = info.class
        local queue = categoryCache[class]

        if isDelete then
            if tolua.cast(obj,"cc.Node") then
                obj:release()
            end
            objsCache[obj] = nil
        else
            --重新入队
            queue.tail = queue.tail + 1
            queue.data[queue.tail] = obj
        end

    end
end
---
--填充池
function fill(class,num,param)
    local totalNum = getTotalObjs(class)
    if totalNum >= num then return end

    for i = 1,num-totalNum do
        local obj = create(class,param)
        release(obj)
    end
end
--

--
function clear()
    for _,v in paris(objsCache) do
        if tolua.cast(v.object,"cc.Node") then
            v.object:release()
        end
    end
    objsCache = {}
    categoryCache = {}
end

