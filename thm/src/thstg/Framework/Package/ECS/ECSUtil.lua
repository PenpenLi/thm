module(..., package.seeall)

local _componentId = 1000
local _entityId = 1000000
local _COMPONENT_SEPARATE_CHAR_ = "@"
function getEntityId()
    _entityId = _entityId + 1
    return _entityId
end

function getComponentId()
    _componentId = _componentId + 1
    return _componentId
end

----
function trans2Name(...)
    local tags = {...}
    local name = ""
    for _,v in ipairs(tags) do
        name = name .. _COMPONENT_SEPARATE_CHAR_ .. tostring(v)
    end
    name = string.sub(name, 2)
    return name
end

function trans2Args(name)
    name = name or ""
    local argsList = string.split(name,_COMPONENT_SEPARATE_CHAR_) or {}
    return argsList
end

function find2Class(name,...)
    local argsA = trans2Args(name)
    local argsB = {...}
    local isMatch = true
    local length = #argsB
    for i = 1,length do
        if argsA[i] ~= argsB[i] then
            return false
        end
    end

    return isMatch
end

--
--使能够找到子类
function find2ClassWithChild(name,...)
    local argsA = trans2Args(name)
    local argsB = {...}
    local isMatch = true
    local length = #argsB
    if #argsB <= 2 and argsA[#argsA] == argsB[#argsB] then
        return true
    else
        for i = 1,length do
            if argsA[i] ~= argsB[i] then
                return false
            end
        end
    end

    return isMatch
end

function match2Class(name,...)
    local argsA = trans2Args(name)
    local argsB = {...}
    local isMatch = true
    local length = math.max(#argsA, #argsB)
    for i = 1,length do
        if argsA[i] ~= argsB[i] then
            return false
        end
    end

    return isMatch
end

-----
---考虑到Entity拥有的脚本数不会很多,因此没有必要使用多重map的形式
local function createNode(data)
    if not data then return nil end
    local Node = {
        isNode = true,
        data = date
    }
    function Node:getDate()
        return self.data
    end
    return Node
end

function add2Value(tb,val,...)
    local tags = {...}
    tb = tb or {}
    local isArgs = tags and next(tags)
    local isAdded = false
    if isArgs then
        if val then
            local ret = tb
            local prevKey = nil
            for _,v in ipairs(tags) do
                if prevKey then
                    ret = ret[prevKey] or {}
                end
                prevKey = v
            end
            if prevKey then
                if ret[prevKey] ~= nil then 
                    isAdded = true 
                else
                    -- table.insert( ret, createNode(val) )
                    ret[prevKey] = createNode(val)
                end
            end
        end
    end
    
    return tb,isArgs,isAdded
end

function get2Value(tb,...)
    local tags = {...}
    local ret = nil
    if tb then
        ret = tb
        for _,v in ipairs(tags) do
            ret = ret[v]
            if ret == nil then return ret end
        end
    end

    if ret.isNode then
        return ret:getData()
    end
    return ret
end

function set2Value(tb,val,...)
    local tags = {...}
    if tb then
        local ret = tb
        local prevKey = nil
        for _,v in ipairs(tags) do
            if prevKey then
                ret = ret[prevKey]
                if ret == nil then return false end
            end
            prevKey = v
        end

        if prevKey then
            ret[prevKey] = createNode(val)
            return true
        end
    end
end
----
function get2Value2(tb,...)
    local tags = {...}
    if tb then
        local ret = tb
        local prevKey = nil
        for _,v in ipairs(tags) do
            if prevKey then
                ret = ret[prevKey]
                if ret == nil then return false end
            end
            prevKey = v
        end
       
        if ret[1] then
            if ret[1].isNode then
                for i = #ret , 1, -1 do
                    if ret[i]:getData():getClass() == prevKey then
                        return ret[i]:getData()
                    end
                end
            else
                return ret[prevKey]
            end
        end

    end
    return nil
end


function remove2Value(tb,...)
    local tags = {...}
    if tb then
        local ret = tb
        local prevKey = nil
        for _,v in ipairs(tags) do
            if prevKey then
                ret = ret[prevKey]
                if ret == nil then return false end
            end
            prevKey = v
        end
       
        if ret[1] then
            if ret[1].isNode then
                for i = #ret , 1, -1 do
                    if ret[i]:getData():getClass() == prevKey then
                        table.remove( ret,i )
                        return true
                    end
                end
            else
                ret[prevKey] = nil
                return true
            end
        end

    end
    return false
end

function visit2Value(val,func)
    --只遍历所有的叶子
    for _,v in pairs(val) do
        if v.isNode then --判断是否为叶子????
            func(val:getData())
        else
            visit2Value(v,func)
        end
    end
end