module("TmplManager", package.seeall)

function getSFXDict(SFXType)
    return Definition.Template.SFX[SFXType]
end

function getEffect(effectType,resName)
    return getSFXDict(SFXType.EFFECT)[effectType][resName]
end


function getParticle(particleType,resName)
    return getSFXDict(SFXType.PARTICLE)[particleType][resName]
end

