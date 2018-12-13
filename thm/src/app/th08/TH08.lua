local M = class("TH08",THSTG.Game)

function M:_onEnv()
    --初始化环境
    require "Scripts.Context.EnvBase"
    require "Scripts.Context.EnvGame"

    return true
end

function M:_onInit()

    --随机数种子
    math.randomseed(os.time())


    return true
end

function M:_onRun()
    --启动场景
    THSTG.SceneManager.runScene(SceneType.MENU)

    THSTG.ModuleManager.open(ModuleType.MENU)
end

return M