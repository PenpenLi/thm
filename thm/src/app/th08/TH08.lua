local M = class("TH08",THSTG.Game)

function M:_onEnv()
    --初始脚本引擎
    require "Scripts.Init"

    return true
end

function M:_onInit()

    --随机数种子
    math.randomseed(os.time())


    return true
end

function M:_onRun()

end

return M