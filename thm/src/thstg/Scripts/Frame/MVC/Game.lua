
local M = class("Game")

function M:ctor()
    self:onCreate()
end

function M:onCreate()

end
function M:createScene()
    return self:onScene()
end

function M:createEnv(gameRoot)
    return self:onEnv(gameRoot)

end

--[[以下函数由子类重载]]--
function M:onEnv(gameRoot)
    --初始化游戏
    return true
end

function M:onScene()
    -- 返回测试窗口
    return nil,nil
end

return M