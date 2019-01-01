local M = class("List")
--FIXME:
local function createNode()
    return {
        data = nil,
        next = nil,
    }
end

function M:ctor()
    self._head = createNode()
end

function M:pushBack(data)
    local newNode = createNode()
    newNode.data = data
    newNode.next = self._head.next
    self._head = newNode
end

function M:insert(data,pos)
    local newNode = createNode()
    pos = math.max(0,pos or 0)
    if pos > 0 then
        local count = 0
        local p = self._head.next
        local prevNode = p
        while (p ~= nil) do
            if count == pos then
                break
            end
            count = count + 1
            prevNode = p
            p = p.next
        end
        newNode.data = data
        newNode.next = prevNode.next
        prevNode.next = newNode
    else
        newNode.data = data
        newNode.next = self._head.next
        self._head = newNode
    end

end

function M:remove(pos)
    local count = 0
    local p = self._head.next
    local prevNode = p
    while (p ~= nil) do
        if count == pos then
            break
        end
        count = count + 1
        prevNode = p
        p = p.next
    end
    prevNode.next = p.next
    p = nil
end

function M:clear()
    self._head = createNode()
end

function M:length()
    local count = 0
    self:visit(function(v)
        count = count + 1
    end)
    return count
end
---

function M:visit(func)
    local p = self._head.next
    while (p ~= nil) do
        func(p)
        p = p.next
    end

end

return M