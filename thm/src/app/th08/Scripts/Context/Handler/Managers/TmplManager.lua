module("TmplManager", package.seeall)

function getEffectDict(effectType)
    return Definition.Template.Effect[effectType]
end

function getParticle(particleType,resName)
    return getEffectDict(EffectType.PARTICLE)[particleType][resName]
end

