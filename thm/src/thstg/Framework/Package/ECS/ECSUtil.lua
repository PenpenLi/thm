module(..., package.seeall)

local _componentId = 1000
local _entityId = 1000000

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
        name = name .. "@".. tostring(v)
    end
    name = string.sub(name, 2)
    return name
end

function trans2Args(name)
    name = name or ""
    local argsList = string.split(name,"@") or {}
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
                    ret[prevKey] = val
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

    return ret
end

function set2Value(tb,val,...)
    local tags = {...}
    if tb then
        ret = tb
        local prevKey = nil
        for _,v in ipairs(tags) do
            if prevKey then
                ret = ret[prevKey] or {}
                if ret == nil then return end
            end
            prevKey = v
        end

        if prevKey then
            ret[prevKey] = val
        end
    end
    
end

function visit2Value(val,func)
    --只遍历所有的叶子
    for _,v in pairs(val) do
        if v.class then --判断是否为叶子????
            func(val)
        else
            visit2Value(v,func)
        end
    end
end