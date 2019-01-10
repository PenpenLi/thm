module("AnimationCache", package.seeall)

local _dict = {}
function getRes(type,fileName,name,time)
    local ret =_dict[type] and _dict[type][name]
    if not ret then
        time = time or Definition.Public.ANIMATION_INTERVAL
        ret = ScenePublic.newAnimation(type,fileName,name,time)
        if ret then
            _dict[type] = _dict[type] or {}
            _dict[type][fileName] = _dict[type][fileName] or {}
            _dict[type][fileName][name] = ret
            ret:retain()
        end
    end
    return ret
    
end

function getResBySheet(fileName,name,time)
    return getRes(TexType.SHEET,fileName,name,time)
end
----

function clear()
    _dict = {}
    for _,v in pairs(_dict) do
        for _,vv in pairs(v) do
            vv:release()
        end
    end
end