module("COMMON", package.seeall)

local M = class("ControlMapper")

function M:ctor()
    self._varKeyToTypeMap = {}
    self._varCountChache = {}
end

function M:registerKey(keyCode,keyType)
    self._varKeyToTypeMap[keyCode] = keyType

end
function M:resetAllKeys()
    self._varCountChache = {}
end

function M:resetKey(type)
    self._varCountChache[type] = 0
end
function M:isKeyDown(type)
    return self._varCountChache[type] and self._varCountChache[type] > 0
end
function M:pressKey(keyCode)
    local keyType = self._varKeyToTypeMap[keyCode]
    if keyType then self._varCountChache[keyType] = (self._varCountChache[keyType] or 0) + 1 end
end
function M:pressKeyOnce(keyCode)
    local keyType = self._varKeyToTypeMap[keyCode]
    if not isKeyDown(keyType) then
        pressKey(keyCode)
    end
end
function M:releaseKey(keyCode)
    local keyType = self._varKeyToTypeMap[keyCode]
    if keyType then self._varCountChache[keyType] = math.max((self._varCountChache[keyType] or 0) - 1,0) end
end

return M