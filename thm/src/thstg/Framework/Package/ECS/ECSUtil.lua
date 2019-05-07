module(..., package.seeall)
local _COMPONENT_SEPARATE_CHAR_ = "/"

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
-- function find2ClassWithChild(name,...)
--     local argsA = trans2Args(name)
--     local argsB = {...}
--     local length = #argsB
--     if length <= 2 then 
--         for i = #argsA,1,-1 do
--             if argsA[i] == argsB[length] then
--                 return true
--             end
--         end
--     else
--         for i = 1,length do
--             if argsA[i] ~= argsB[i] then
--                 return false
--             end
--         end
--         return true
--     end

--     return false
-- end

--使能够找到子类
--模式匹配,改进算法
function find2ClassWithChild(nameArgs,...)
    local argsA = nameArgs
    local argsB = {...}

    -- if #argsB == 1 then argsB = trans2Args(argsB) end

    local lengthA,lengthB = #argsA,#argsB
    local i,j = lengthA,lengthB
    --[[
        脚本的匹配加了标志,会出错,如
        ScriptComponent BaseController PlayerController 
        ScriptComponent PlayerController
        然而组件是没有头标识的,改为不加头标识,和组件一致,(因为加不加都没什么用,这块没做优化)
    ]]
    while (i>0 and j>0) do
        if argsA[i] == argsB[j] then
            i = i - 1
            j = j - 1
        else
            i = i + (lengthB - j) - 1
            j = lengthB
        end
    end
    return (j ~= lengthB)
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