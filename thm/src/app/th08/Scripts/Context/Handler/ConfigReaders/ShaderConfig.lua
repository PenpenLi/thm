module("ShaderConfig", package.seeall)

local _dict = false
local function getDict()
    if not _dict then
        _dict = require "Scripts.Configs.Handwork.Shader"
    end
    return _dict
end

function getShader(shaderKey)
    local tb = getDict()
    local info = tb[shaderKey]
    return info.vertexShader,info.fragmentShader
end