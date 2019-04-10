module("SEXFactory", package.seeall)

local EFFECT_PATH_PATTERN = "Scripts.Template.SEX.Effect.Effect"
local PARTICLE_PATH_PATTERN = "Scripts.Template.SEX.Particle.Particle"

local function getDictByFile(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end

function getEffectDict() return getDictByFile(EFFECT_PATH_PATTERN) end
function getEffect(effectType,name) return getEffectDict()[effectType][name] end

function getParticleDict() return getDictByFile(PARTICLE_PATH_PATTERN) end
function getParticle(particleType,name) return getParticleDict()[particleType][name] end