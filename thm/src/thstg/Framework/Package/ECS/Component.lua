local M = class("Component")

function M:ctor()
    --用于标识组件类别
    self.__componentName__ = _onName() or self.class.__cname

    self:_onInit()
end

function M:getName()
    return self.__componentName__
end

--
--[[以下函数必须重载]]
--用于初始化数据
function M:_onInit()

end

function M:_onName()   
    -- error("[Component] The _onName function must be overrided!")
    return false
end




return M