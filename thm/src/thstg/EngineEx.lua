
__ENGINE_VERSION__ = 10000

EngineEx = class("EngineEx")

function EngineEx:ctor(configs)
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

function EngineEx:run()
    local gamePath = self._configs.gameRoot .. "." ..self._configs.gameName
 
    local Game = require(gamePath).new()

    --初始化环境
    if Game:createEnv(self._configs.gameRoot) then
        Game:run()
    end
   
end

return EngineEx