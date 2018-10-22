local M = class("Cache")

function M:clear(...)
    self:_onClear()
end

--清空缓存,待子类重写
function M:_onClear()

end



return M