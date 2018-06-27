
local MyApp = class("MyApp", cc.load("mvc").AppBase)

--重写ctor函数
function MyApp:ctor()
    local configs = {
        viewsRoot  = "app.th08.modules.main",
        modelsRoot = "app.th08.modules.main",
        defaultSceneName = "MainScene",
    }
    MyApp.super.ctor(self, configs)   
end

function MyApp:onCreate()
    math.randomseed(os.time())
end

return MyApp
