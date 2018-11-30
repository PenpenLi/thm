local M = class("TH08",THSTG.Game)

function M:_onEnv()
    --初始化环境
    require "Scripts.Game.EnvBase"
    require "Scripts.Game.EnvGame"

    return true
end

function M:_onInit()

    --随机数种子
    math.randomseed(os.time())


    return true
end

function M:_onRun()
    --启动管理器
    FlowManager.run()

end

return M