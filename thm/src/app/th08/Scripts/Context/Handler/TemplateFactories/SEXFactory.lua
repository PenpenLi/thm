module("SEXFactory", package.seeall)

local EFFECT_PATH_PATTERN = "Scripts.Template.SEX.F_Effect"
local PARTICLE_PATH_PATTERN = "Scripts.Template.SEX.F_Particle"

local function getDictByFile(path,file)
    local pathFile = string.format(path,file)
    return require(pathFile)
end

function getEffectDict() return getDictByFile(EFFECT_PATH_PATTERN) end
function getEffect(name) return getEffectDict()[name] end

function getParticleDict() return getDictByFile(PARTICLE_PATH_PATTERN) end
function getParticle(name) return getParticleDict()[name] end

--------------------------------
