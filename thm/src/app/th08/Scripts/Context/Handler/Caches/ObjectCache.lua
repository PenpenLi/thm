module("ObjectCache", package.seeall)

local objsCache = {}            --所有对象缓存的信息
local categoryCache = {}

----
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

