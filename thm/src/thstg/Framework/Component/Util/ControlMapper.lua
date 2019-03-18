
local M = class("ControlMapper")
function M:ctor()
    self:clear()
end
function M:clear()
    self._varTypeToKeyMap = {}
    self._varKeyToTypeMap = {}
    self._varCountChache = {}
end

function M:registerKey(keyCode,keyType)
    self._varKeyToTypeMap[keyCode] = keyType
    self._varTypeToKeyMap[keyType] = self._varTypeToKeyMap[keyType] or {}
    self._varTypeToKeyMap[keyType][keyCode] = false
end

function M:unregisterKey(keyCode)
    local keyType = self._varKeyToTypeMap[keyCode]
    if keyType then
        self._varKeyToTypeMap[keyCode] = nil
        self._varTypeToKeyMap[keyType][keyCode] = nil
    end
end

function M:unregisterKeyByType(keyType)
    local keyCodes = self._varTypeToKeyMap[keyType]
    if keyCodes then
        for keyCode,_ in pairs(keyCodes) do
            self._varKeyToTypeMap[keyCode] = nil
        end
        self._varTypeToKeyMap[keyType] = nil
    end
end

function M:unregisterAllKeys()
    self._varTypeToKeyMap = {}
    self._varKeyToTypeMap = {}
end

function M:isKeyDown(keyType)
    return self._varCountChache[keyType] and (self._varCountChache[keyType] > 0) or false 
end

function M:getDownCount(keyType)
    return self._varCountChache[keyType] and self._varCountChache[keyType] or 0
end

function M:getKeyType(keyCode)
    local keyType = self._varKeyToTypeMap[keyCode]
    return keyType
end
function M:pressKeyAgain(keyCode)
    local keyType = self:getKeyType(keyCode)
    if keyType then 
        self._varCountChache[keyType] = (self._varCountChache[keyType] or 0) + 1 
        self._varTypeToKeyMap[keyType][keyCode] = true
    end
end
function M:pressKey(keyCode)
    local keyType = self:getKeyType(keyCode)
    if keyType then
        if not self._varTypeToKeyMap[keyType][keyCode] then
            self:pressKeyAgain(keyCode)
        end
    end
end
function M:releaseKey(keyCode)
    local keyType = self:getKeyType(keyCode)
    if keyType then 
        self._varCountChache[keyType] = math.max((self._varCountChache[keyType] or 0) - 1,0) 
        self._varTypeToKeyMap[keyType][keyCode] = false
    end
end

function M:releaseAllKeys()
    self._varCountChache = {}
end

function M:resetKey(keyType)
    self._varCountChache[keyType] = 0
    local keyMap = self._varTypeToKeyMap[keyType]
    if keyMap then
        for k,_ in pairs(keyMap) do
            self:releaseKey(k)
        end
    end
end

return M
