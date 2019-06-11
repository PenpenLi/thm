module(..., package.seeall)
local _COMPONENT_SEPARATE_CHAR_ = "/"

----
function trans2Path(...)
    local tags = {...}
    local name = ""
    for _,v in ipairs(tags) do
        --不要使用..,影响性能
        name = string.format("%s%s%s", name, _COMPONENT_SEPARATE_CHAR_, v)
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

--使能够找到子类
--模式匹配,改进算法
function find2ClassWithChildByClassList(classList,...)
    local argsA = classList
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

function find2ClassWithChildByClassMap(classMap,...)
    local argsB = {...}
    for i = #argsB,1,-1 do
        if classMap[argsB[i]] then
            return true
        end
    end
    return false
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

function trans2ClassInfo(obj,ctorArgs)
    local function reverseTable(tab)
        local tmp = {}
        for i = 1, #tab do
            local key = #tab
            tmp[i] = table.remove(tab)
        end
        return tmp
    end

    local classTable = {}
    local classList = {}
    local this = obj
    while this do
        -- if not this.super then break end    --不包括最顶层,没有意义
        local keys = this:_onClass(this.__cname or "UnknowClass" , this.__id__ , ctorArgs)
        for i = #keys,1,-1 do
            table.insert(classList, keys[i])
            classTable[keys[i]] = keys[i]
        end
        this = this.super
        
    end
    classList = reverseTable(classList)
    return trans2Path(unpack(classList)),classList,classTable
end