local M = class("List")
 
function M:ctor(t)
    self.itemType = t
end
 
function M:add(item)
    table.insert(self, item)
end
 
function M:clear()
    local count = self:count()
    for i=count,1,-1 do
        table.remove(self)
    end
end
 
function M:contains(item)
    local count = self:count()
    for i=1,count do
        if self[i] == item then
            return true
        end
    end
    return false
end
 
function M:count()
    return table.getn(self)
end

function M:length()
    return self:count()
end
 
function M:find(predicate)
    if (predicate == nil or type(predicate) ~= 'function') then
        print('predicate is invalid!')
        return
    end
    local count = self:count()
    for i=1,count do
        if predicate(self[i]) then 
            return self[i] 
        end
    end
    return nil
end
 
function M:forEach(action)
    if (action == nil or type(action) ~= 'function') then
        print('action is invalid!')
        return
    end
    local count = self:count()
    for i=1,count do
        action(self[i])
    end
end
 
function M:indexOf(item)
    local count = self:count()
    for i=1,count do
        if self[i] == item then
            return i
        end
    end
    return 0
end
 
function M:lastIndexOf(item)
    local count = self:count()
    for i=count,1,-1 do
        if self[i] == item then
            return i
        end
    end
    return 0
end
 
function M:insert(index, item)
    table.insert(self, index, item)
end
 
function M:itemType()
    return self.itemType
end
 
function M:remove(item)
    local idx = self:lastIndexOf(item)
    if (idx > 0) then
        table.remove(self, idx)
        self:remove(item)
    end
end
 
function M:removeAt(index)
    table.remove(self, index)
end
 
function M:sort(comparison)
    if (comparison ~= nil and type(comparison) ~= 'function') then
        print('comparison is invalid')
        return
    end
    if func == nil then
        table.sort(self)
    else
        table.sort(self, func)
    end
end

return M