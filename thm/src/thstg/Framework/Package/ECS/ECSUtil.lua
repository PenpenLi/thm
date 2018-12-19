module(..., package.seeall)

local _componentId = 1000
local _entityId = 1000000

function getEntityId()
    _entityId = _entityId + 1
    return _entityId
end

function getComponentId()
    _componentId = _componentId + 1
    return _componentId
end

function trans2Name(...)
    local tags = {...}
    local name = ""
    for _,v in ipairs(tags) do
        name = name .. "_".. tostring(v)
    end
    name = string.sub(name, 2)
    return name
end