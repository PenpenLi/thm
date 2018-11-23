local M = class("Stack")

function M:ctor()
    self._varObjStack = {}
    self._varTop = 0

end

function M:push(data)
    self._varTop = self._varTop + 1
    self._varObjStack[self._varTop] = data
    return true
end

function M:pop()
    if self:isEmpty() then
        return 
    end
    self._varObjStack[self._varTop] = nil
    self._varTop = self._varTop - 1

end

function M:top(default)
    if self:isEmpty() then
        return default
    end
    return self._varObjStack[self._varTop]
end

function M:clear()
    while( not self:isEmpty() ) do self:pop() end
    self._varObjStack = {}
    self._varTop = 0
end

function M:isEmpty()
    return self._varTop <= 0
end

function M:length()
    return self._varTop
end


return M