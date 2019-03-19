module(..., package.seeall)

local CCSAudioEngine = cc.SimpleAudioEngine:getInstance()

function preloadMusic(filePath)
    CCSAudioEngine:preloadMusic(filePath)
end

function playMusic(filePath,isLood)
    isLood = isLood or false
    return CCSAudioEngine:playMusic(filePath,isLood)
end

function stopMusic(releaseData)
    releaseData = releaseData or false
    return CCSAudioEngine:stopMusic(releaseData)
end

function resumeMusic()
    CCSAudioEngine:resumeMusic()
end

function rewindMusic()
    CCSAudioEngine.rewindMusic()
end

function isMusicPlaying()
    CCSAudioEngine.isMusicPlaying()
end

function setMusicVolume(volume)
    CCSAudioEngine.setMusicVolume(volume)
end

----------------------------
function preloadEffect(filePath)
    CCSAudioEngine:preloadEffect(filePath)
end

function playEffect(filePath,loop,pitch,pan,gain)
    loop = loop or false
    pitch = pitch or 1.0
    pan = pan or 0
    gain = gain or 1.0
    --
    return CCSAudioEngine:playEffect(filePath,loop,pitch,pan,gain)

end

function setEffectsVolume(volume)
    CCSAudioEngine:setEffectsVolume(volume)
end

function resumeEffect(soundId)
    CCSAudioEngine:resumeEffect(soundId)
end

function stopEffect(soundId)
    CCSAudioEngine:stopEffect(soundId)
end
