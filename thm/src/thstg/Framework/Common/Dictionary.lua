
local M = class("Dictionary")

function M:ctor(tk, tv)
    self.keyType = tk
    self.valueType = tv
end
 
function M:add(key, value)
    if self[key] == nil then
        self[key] = value
        table.insert(self.keyList, key)
    else
        self[key] = value
    end
end
 
function M:clear()
    local count = self:count()
    for i=count,1,-1 do
        self[self.keyList[i]] = nil
        table.remove(self.keyList)
    end
end
 
function M:containsKey(key)
    local count = self:count()
    for i=1,count do
        if self.keyList[i] == key then
            return true
        end
    end
    return false
end
 
function M:containsValue(value)
    local count = self:count()
    for i=1,count do
        if self[self.keyList[i]] == value then
            return true
        end
    end
    return false
end
 
function M:count()
    return table.getn(self.keyList)
end
 
function M:iter()
    local i = 0
    local n = self:count()
    return function ()
        i = i + 1
        if i <= n then
            return self.keyList[i]
        end
        return nil
    end
end
 
function M:remove(key)
    if self:containsKey(key) then
        local count = self:count()
        for i=1,count do
            if self.keyList[i] == key then
                table.remove(self.keyList, i)
                break
            end
        end
        self[key] = nil
    end
end
 
function M:keyType()
    return self.keyType
end
 
function M:valueType()
    return self.valueType
end