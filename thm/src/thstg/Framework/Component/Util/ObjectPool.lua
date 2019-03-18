

local M = class("ObjectPool")
function M:ctor()
    self._objsCache = {}            --所有对象缓存的信息
    self._categoryCache = {}
end

--自动扩充
function M:create(class,param)
    if type(class) == "table" then
        --取得队列
        local queue = self:_getObjcetQueue(class)
        --没有可用的对象,现场做一个
        if queue.front == queue.tail then
            self:_addNewObject(queue,class,params)
        end

        --出队
        queue.front = queue.front + 1
        return queue.data[queue.front]

    end
    return nil
end

function M:release(obj,isDelete)
    local info = self._objsCache[obj]
    if info then
        local class = info.class
        local queue = self._categoryCache[class]

        if isDelete then
            if tolua.iskindof(obj,"cc.Node") then
                obj:release()
            end
            self._objsCache[obj] = nil
        else
            --重新入队
            queue.tail = queue.tail + 1
            queue.data[queue.tail] = obj
        end
        return true
    end
    return false
end

function M:pick(class,num,initFunc,params)
    local list = {}
    initFunc = initFunc or function(...) end
    for i = 1,num do
        local obj = create(class,params)
        initFunc(obj,i)
        table.insert(list, obj)
    end
    return obj
end

function M:throw(objs,isDelete,delFunc)
    delFunc = delFunc or function(...) end
    for k,v in pairs(objs) do
        local ret = self:release(v,isDelete)
        delFunc(v,k,ret)
    end
end

function M:releaseAll(class,isDelete)
    local queue = self._categoryCache[class]
    if queue then
        for _,v in pairs(queue) do 
            self:release(v,isDelete)
        end
    end
end
---
--填满池
function M:fill(class,num,param)
    local totalNum = self:_getTotalObjs(class)
    if totalNum >= num then return end
    local queue = self:_getObjcetQueue(class)
    for i = 1,num-totalNum do
        self:_addNewObject(queue,class,params)
    end

end
--
function M:expand(class,num,param)
    local queue = self:_getObjcetQueue(class)
    for i = 1,num do
        self:_addNewObject(queue,class,params)
    end
    
end
--

function M:clearAll()
    for _,v in paris(self._objsCache) do
        if tolua.iskindof(v.object,"cc.Node") then
            v.object:release()
        end
    end
    self._objsCache = {}
    self._categoryCache = {}
end


function M:clear(class)
    if class then
        for _,v in paris(self._objsCache) do
            if info.class == class then
                self:release(v.obj)
            end
        end
        self._categoryCache[class] = nil
    else
        self:clearAll()
    end
end

----
function M:_getTotalObjs(class)
    local num = 0
    for _,v in pairs(self._objsCache) do
        if v.class == class then
            num = num + 1
        end
    end
    return num
end

function M:_getAvailableObjs(class)
    if not self._categoryCache[class] then return 0 end

    local queue = self._categoryCache[class]
    return (queue.tail - queue.front)
end

function M:_getObjcetQueue(class)
    if type(class) == "table" then
        local queue = nil
        if not self._categoryCache[class] then
            --创建一个对象并返回
            queue = {front = 0,tail = 0,data = {}}
            self._categoryCache[class] = queue
        else
            queue = self._categoryCache[class]
        end
        return queue
    end
    return nil
end

function M:_addNewObject(queue,class,params)
    if type(class) == "table" and type(queue) == "table" then
        local obj = class.new(param)
        self._objsCache[obj] = {
            class = class,
            object = obj
        }

        if tolua.iskindof(obj,"cc.Node") then
            obj:retain()
        end

        --入队
        queue.tail = queue.tail + 1
        queue.data[queue.tail] = obj
    end
end

return M