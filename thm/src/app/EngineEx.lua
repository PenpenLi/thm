local EngineEx = class("EngineEx")

function AppBase:createView(name)
    for _, root in ipairs(self.configs_.viewsRoot) do
        local packageName = string.format("%s.%s", root, name)
        local status, view = xpcall(function()
                return require(packageName)
            end, function(msg)
            if not string.find(msg, string.format("'%s' not found:", packageName)) then
                print("load view error: ", msg)
            end
        end)
        local t = type(view)
        if status and (t == "table" or t == "userdata") then
            return view:create(self, name)
        end
    end
    error(string.format("AppBase:createView() - not found view \"%s\" in search paths \"%s\"",
        name, table.concat(self.configs_.viewsRoot, ",")), 0)
end

function EngineEx:showWithScene(transition, time, more)
    self:setVisible(true)
    local scene = display.newScene(self.name_)
    scene:addChild(self)
    display.runScene(scene, transition, time, more)
    return self
end


function EngineEx:enterScene(scene)
    local view = self:createView(sceneName)
    view:showWithScene(transition, time, more)
    return view
end

--TODO:游戏

function EngineEx:run(gameName)
    local gamepath = "app" .. gameName .. "Game"
    local game = require(gamepath)

    --初始化环境


    --创建场景
    local mainScene = game:onScene()

    self:enterScene(initSceneName)
end