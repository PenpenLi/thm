module("COMMON", package.seeall)

local ControlMapper = class("ControlMapper")
function ControlMapper:ctor()
    self:clear()
end
function ControlMapper:clear()
    self._varTypeToKeyMap = {}
    self._varKeyToTypeMap = {}
    self._varCountChache = {}
end

function ControlMapper:registerKey(keyCode,keyType)
    self._varKeyToTypeMap[keyCode] = keyType
    self._varTypeToKeyMap[keyType] = self._varTypeToKeyMap[keyType] or {}
    self._varTypeToKeyMap[keyType][keyCode] = false
end

function ControlMapper:unregisterKey(keyCode)
    local keyType = self._varKeyToTypeMap[keyCode]
    if keyType then
        self._varKeyToTypeMap[keyCode] = nil
        self._varTypeToKeyMap[keyType][keyCode] = nil
    end
end

function ControlMapper:unregisterKeyByType(keyType)
    local keyCodes = self._varTypeToKeyMap[keyType]
    if keyCodes then
        for keyCode,_ in pairs(keyCodes) do
            self._varKeyToTypeMap[keyCode] = nil
        end
        self._varTypeToKeyMap[keyType] = nil
    end
end

function ControlMapper:unregisterAllKeys()
    self._varTypeToKeyMap = {}
    self._varKeyToTypeMap = {}
end

function ControlMapper:isKeyDown(keyType)
    return self._varCountChache[keyType] and self._varCountChache[keyType] > 0
end

function ControlMapper:getDownCount(keyType)
    return self._varCountChache[keyType] and self._varCountChache[keyType] or 0
end

function ControlMapper:getKeyType(keyCode)
    local keyType = self._varKeyToTypeMap[keyCode]
    return keyType
end
function ControlMapper:pressKeyAgain(keyCode)
    local keyType = self:getKeyType(keyCode)
    if keyType then 
        self._varCountChache[keyType] = (self._varCountChache[keyType] or 0) + 1 
        self._varTypeToKeyMap[keyType][keyCode] = true
    end
end
function ControlMapper:pressKey(keyCode)
    local keyType = self:getKeyType(keyCode)
    if keyType then
        if not self._varTypeToKeyMap[keyType][keyCode] then
            self:pressKeyAgain(keyCode)
        end
    end
end
function ControlMapper:releaseKey(keyCode)
    local keyType = self:getKeyType(keyCode)
    if keyType then 
        self._varCountChache[keyType] = math.max((self._varCountChache[keyType] or 0) - 1,0) 
        self._varTypeToKeyMap[keyType][keyCode] = false
    end
end

function ControlMapper:releaseAllKeys()
    self._varCountChache = {}
end

function ControlMapper:resetKey(keyType)
    self._varCountChache[keyType] = 0
    local keyMap = self._varTypeToKeyMap[keyType]
    if keyMap then
        for k,_ in pairs(keyMap) do
            self:releaseKey(k)
        end
    end
end

-----

function newControlMapper(params)
    params = params or {}
    local controlMapper = ControlMapper:create()
    for k,v in pairs(params) do
        controlMapper:registerKey(k,v)
    end
    return controlMapper
end