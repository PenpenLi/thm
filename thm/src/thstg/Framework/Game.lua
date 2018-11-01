
local M = class("Game")

function M:ctor()
    self:onCreate()
end

function M:onCreate()

end

function M:createScene()
    return self:_onScene()
end

function M:createEnv(gameRoot)

    -------------------------
    --添加LUA包含路径
    local newPath = string.gsub(gameRoot, "%.", "/")    --转移
    package.path = package.path .. ';' .. newPath .. '/?.lua'

    --添加资源路径
    cc.FileUtils:getInstance():addSearchPath("src/" .. newPath .. "/")

    --子类初始化
    return self:_onEnv(gameRoot)

end

--[[以下函数由子类重载]]--
function M:_onEnv(gameRoot)  

    --初始化游戏
    return true
end

function M:_onScene()
    local scene = SCENE.newScene()
    local label = UI.newLabel({
        x = display.cx,
        y = display.cy,
        anchorPoint = UI.POINT_CENTER,
        text = "THSTG"
    })
    scene:addChild(label)
    --------


    -- 返回测试窗口
    return scene,nil
end


Game = M
return M
