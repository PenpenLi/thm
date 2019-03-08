module("UTIL", package.seeall)

FuncHookHandler = class("FuncHookHandler")
function FuncHookHandler:ctor()
    self._id = 1
    self._hookCache = {}
end

function FuncHookHandler:hook(instane,funcStr,newFunc)
    local oldFunc = instane[funcStr]
    self._hookCache[self._id] = {
        instane = instane,
        funcStr = funcStr,
        oldFunc = oldFunc,
    }

    instane[funcStr] = function (...)
        newFunc(instane,oldFunc,...)
    end
    self._id = self._id + 1
end

function FuncHookHandler:unhook(id)
    local info = self._hookCache[id]
    if info then
        info.instane[info.funcStr] = info.oldFunc
        self._hookCache[id] = nil
    end
end

----------------
function newFuncHookHandler(cfg)
    local instance = FuncHookHandler.new()
    return instance
end
