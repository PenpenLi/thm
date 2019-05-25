local M = {}
local Engine = THSTG.AudioEngine
local _rid2sidMap = {}

local function _getFilePathById(rid)
    return SoundConfig.getFilePath(rid)
end

local function _getSoundIdByResId(rid)
    return _rid2sidMap[rid]
end

function M.preloadMusic(rid)
    local src = _getFilePathById(rid)
end

function M.playMusic(rid)
    local src = _getFilePathById(rid)
end

function M.isMusicPlaying(rid)
    local sid = _getSoundIdByResId(rid)
end

function M.stopMusic(rid)
    local sid = _getSoundIdByResId(rid)
end

----
function M.preloadEffect(rid)
    local src = _getFilePathById(rid)
end

function M.playEffect(rid)
    local src = _getFilePathById(rid)
end

function M.isEffectPlaying(rid)
    local sid = _getSoundIdByResId(rid)
end

function M.stopEffect(rid)
    local sid = _getSoundIdByResId(rid)
end


return M