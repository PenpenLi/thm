
local MyApp = class("MyApp", cc.load("mvc").AppBase)

--重写ctor函数
function MyApp:ctor()

    --加载入口配置文件
    local enterConfig = {
        viewsRoot  = "app.th08.Modules.Scenes.Main",
        modelsRoot = "app.th08.Modules.Scenes.Main",
        defaultSceneName = "MainScene",
    }

    --执行父类构造函数
    MyApp.super.ctor(self, enterConfig)   
end

function MyApp:onCreate()
    math.randomseed(os.time())
end

return MyApp
