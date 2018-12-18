module("AnimationCache", package.seeall)

local _dict = {}
function getRes(type,name,time)
    local ret =_dict[type] and _dict[type][name]
    if not ret then
        time = time or Definition.Public.ANIMATION_INTERVAL
        ret = ScenePublic.newAnimation(type,name,time)
        if ret then
            _dict[type] = _dict[type] or {}
            _dict[type][name] = ret
            ret:retain()
        end
    end
    return ret
    
end

function getSheetRes(name,time)
    return getRes(TexType.SHEET,name,time)
end

function clear()
    _dict = {}
    for _,v in pairs(_dict) do
        for _,vv in pairs(v) do
            vv:release()
        end
    end
end