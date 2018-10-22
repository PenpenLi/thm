
__ENGINE_VERSION__ = 10000

local M = class("EngineEx")

function M:ctor(configs)
    self._configs = self._configs or {}

    for k, v in pairs(configs or {}) do
        self._configs[k] = v
    end

    if DEBUG > 1 then
        dump(self._configs, "AppBase configs")
    end

    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end

end

function M:run()
    local gamePath = self._configs.gameRoot .. "." ..self._configs.gameName
 
    local game = require(gamePath):create()

    --初始化环境
    local state = game:createEnv(self._configs.gameRoot)
    --创建场景
    local mainScene,transition = game:createScene()

    --运行
    mainScene:showWithScene(transition)
    

end

EngineEx = M
return M