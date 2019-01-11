module("SEXManager", package.seeall)


local EFFECT_PATH_PATTERN = "Scripts.Configs.Handwork.SEX.Effect.Effect"

local function getDictByFile(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end

function getSEXEffectDict() 
    local tb = getDictByFile(EFFECT_PATH_PATTERN)
    return tb
end
function getSEXEffect(effectType,name) return getSEXEffectDict()[effectType][name] end