module("THSTG", package.seeall)
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
    --添加LUA包含路径
    local newPath = string.gsub(gameRoot, "%.", "/")    --转移
    package.path = package.path .. ';' .. newPath .. '/?.lua'

    --添加资源路径
    cc.FileUtils:getInstance():addSearchPath("src/" .. newPath .. "/")

    --子类初始化
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

_G.Game = M
return M
