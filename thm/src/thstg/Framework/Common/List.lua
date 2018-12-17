local M = class("List")
--TODO:
local function createNode()
    return {
        data = data,
        next = next,
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
  
end

function M:remove(pos)

end

function M:clear()

end

function M:length()

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