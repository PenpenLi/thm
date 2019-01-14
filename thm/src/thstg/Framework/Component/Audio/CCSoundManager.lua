--音乐管理器
module("AUDIO", package.seeall)

local AudioEngine = ccexp.AudioEngine
local FileUtils = cc.FileUtils:getInstance()
-- local textureManager = TextureManager:getInstance()

INVALID_AUDIO_ID = -1

--是否处于静音状态
local _isSilence = false
--背景音量[0-100]
local _musicVolume = 100
--特效音量[0-100]
local _soundVolume = 100

--是否处于语音模式中（录音或播放语音状态）
local _isVoiceMode = false
--录音或播放语音前音量保存
local _savedMusicVolume, _savedSoundVolume = 0, 0

--正在播放中的背景音乐
local _playingMusic = INVALID_AUDIO_ID
local _playingMusicPath = nil

--正在播放中的音效
local _playingSounds = {}

--移除下载监听
local removeEventListener = function() end


--------------------------------音乐----------------------------------

--播放音乐 循环播放 参数id为地图id--切换地图ID时会回收上次地图的所有音效和音乐资源--
function playMusic(filePath, loadCall)
	if __IN_AUDITING__ then
		return INVALID_AUDIO_ID
	end

	removeEventListener()
	local exist, filePath = FileUtils:isFileExist(filePath),filePath
	if not exist then
		-- if __ENGINE_VERSION__ >= 50 and filePath then
		-- 	if textureManager:isFileExistGame(filePath) then
		-- 		textureManager:toDownloadRes(filePath)
		-- 		local function onMissingResGet(_, _, path)
		-- 			if path == filePath then
		-- 				playMusic(musicKey, loadCall)
		-- 			end
		-- 		end
		-- 		Dispatcher.addEventListener(EventType.MISSING_RESOURCE_GET, onMissingResGet)
		-- 		removeEventListener = function()
		-- 			Dispatcher.removeEventListener(EventType.MISSING_RESOURCE_GET, onMissingResGet)
		-- 			removeEventListener = function() end
		-- 		end
		-- 	end
		-- end
		print("Error! The key [" .. filePath .. "] is not exist!")
		return INVALID_AUDIO_ID
	end
	
	return playCustomMusic(filePath, loadCall)
end

function playCustomMusic(filePath, callback)
	if __IN_AUDITING__ then
		return INVALID_AUDIO_ID
	end

	removeEventListener()
	if _playingMusic ~= INVALID_AUDIO_ID then
		if filePath ~= _playingMusicPath then
			AudioEngine:stop(_playingMusic)
			AudioEngine:uncache(_playingMusicPath)
			_playingMusicPath = ""
		else
			return _playingMusic
		end
	end

	local volume = _musicVolume
	if _isSilence then volume = 0 end

	if callback and "function" == type(callback) then
		AudioEngine:preload(filePath, function(isloadSuccess)
			callback(isloadSuccess)
		end)
	end
	_playingMusic = AudioEngine:play2d(filePath, true, volume / 100)
	if _playingMusic ~= INVALID_AUDIO_ID then
		_playingMusicPath = filePath
	end

	return _playingMusic
end

--停止播放音乐-不可恢复
function stopMusic()
	removeEventListener()
	if _playingMusic ~= INVALID_AUDIO_ID then
		AudioEngine:stop(_playingMusic)
		_playingMusic = INVALID_AUDIO_ID
		_playingMusicPath = nil
		return true
	end

	_playingMusic = INVALID_AUDIO_ID
	_playingMusicPath = nil
	return false
end

--暂停背景音乐
function pauseMusic()
	if _playingMusic ~= INVALID_AUDIO_ID then
		AudioEngine:pause(_playingMusic)
		return true
	end
	return false
end

--恢复背景音乐
function resumeMusic()
	if _playingMusic ~= INVALID_AUDIO_ID then
		AudioEngine:resume(_playingMusic)
		return true
	end
	return false
end

--重新开始播放背景音乐
function restartMusic()
	if _playingMusic ~= INVALID_AUDIO_ID then
		AudioEngine:setCurrentTime(_playingMusic, 0)
		return true
	end

	return false
end

--设置背景音乐音量[0-100]
function getMusicVolume() return _musicVolume end
function setMusicVolume(value)
	if type(value) ~= "number" then return end

	if value < 0 then
		value = 0
	elseif value > 100 then
		value = 100
	end

	if _musicVolume ~= value then
		_musicVolume = value

		local volume = _musicVolume
		if _isSilence then volume = 0 end

		if _playingMusic ~= INVALID_AUDIO_ID then
			AudioEngine:setVolume(_playingMusic, volume / 100)
		end
	end
end

--得到音乐总时间长度
function getMusicDuration()
	if _playingMusic ~= INVALID_AUDIO_ID then
		return AudioEngine:getDuration(_playingMusic)
	end

	return 0
end

--得到音乐当前播放时间
function getMusicCurrentTime()
	if _playingMusic ~= INVALID_AUDIO_ID then
		return AudioEngine:getCurrentTime(_playingMusic)
	end

	return 0
end

--设置音乐当前播放时间 返回成功与否
function setMusicCurrentTime(curTime)
	--无效判断
	if _playingMusic == INVALID_AUDIO_ID then
		return false
	end
	--音乐长度
	local timeLength = AudioEngine:getDuration(_playingMusic)
	-- print(__SELF_PRINT_TYPE__, timeLength, _playingMusic, curTime)
	if timeLength <= 0 then
		return false
	end
	-- print(__SELF_PRINT_TYPE__, "-----",timeLength, _playingMusic, curTime)
	--处理参数
	curTime = (not curTime) and 0 or curTime
	curTime = (curTime < 0) and 0 or curTime
	curTime = (curTime > timeLength) and timeLength or curTime

	--设置时间
	AudioEngine:setCurrentTime(_playingMusic, curTime)

	return true
end


--------------------------------音效----------------------------------

--播放音效--ResKey资源配置的key-返回音效ID
function playSound(filePath, isLoop, endCallback)
	isLoop = isLoop or false
	local exist, filePath = filePath
	if not exist then
		-- if filePath then
		-- 	textureManager:toDownloadRes(filePath)
		-- end
		print("Error! The key " .. filePath .. " is not exist!")
		return INVALID_AUDIO_ID
	end

	local volume = _soundVolume
	if _isSilence then volume = 0 end

	if volume <= 0 then return INVALID_AUDIO_ID end

	local soundId = AudioEngine:play2d(filePath, isLoop, volume / 100)
	if soundId ~= INVALID_AUDIO_ID then
		local function onPlayEnd(id, path)
			_playingSounds[id] = nil
			if type(endCallback) == "function" then
				endCallback(filePath,id)
			end 
		end
		AudioEngine:setFinishCallback(soundId, onPlayEnd)
		_playingSounds[soundId] = filePath
	end

	return soundId
end

--停止播放音效 soundId 调用播放特效时返回的音效ID
function stopSound(soundId)
	if _playingSounds[soundId] then
		AudioEngine:stop(soundId)
		_playingSounds[soundId] = nil
	end
end

--停止所有音效
function stopSounds()
	for k, v in pairs(_playingSounds) do
		AudioEngine:stop(k)
	end
	_playingSounds = {}
end

--暂停指定音效
function pauseSound(soundId)
	if _playingSounds[soundId] then
		AudioEngine:pause(soundId)
	end
end

--暂停所有音效
function pauseSounds()
	for k, v in pairs(_playingSounds) do
		AudioEngine:pause(k)
	end
end

--恢复指定音效--
function resumeSound(soundId)
	if _playingSounds[soundId] then
		AudioEngine:resume(soundId)
	end
end

--恢复所有暂停的音效--
function resumeSounds()
	for k, v in pairs(_playingSounds) do
		AudioEngine:resume(k)
	end
end

--设置音效音量--对当前正在播放的无效--value[0, 100]
function getSoundVolume() return _soundVolume end
function setSoundVolume(value)
	if type(value) ~= "number" then return end

	if value < 0 then
		value = 0
	elseif value > 100 then
		value = 100
	end

	if _soundVolume ~= value then
		_soundVolume = value

		local volume = _soundVolume
		if _isSilence then volume = 0 end

		for k, v in pairs(_playingSounds) do
			AudioEngine:setVolume(k, volume / 100)
		end
	end
end


-----------------------------新增API----------------------------

--设置是否静音
function getIsSilence() return _isSilence end
function setIsSilence(value)
	if _isSilence ~= value then
		_isSilence = value

		if _playingMusic ~= INVALID_AUDIO_ID then
			local volume = _musicVolume
			if _isSilence then volume = 0 end
			AudioEngine:setVolume(_playingMusic, volume / 100)
		end

		local volume = _soundVolume
		if _isSilence then volume = 0 end
		for k, v in pairs(_playingSounds) do
			AudioEngine:setVolume(k, volume / 100)
		end
	end
end

--语音模式
function getIsVoiceMode() return _isVoiceMode end
function setIsVoiceMode(value)
	if type(value) ~= "boolean" then return end

	if _isVoiceMode ~= value then
		_isVoiceMode = value

		if _isVoiceMode then
			_savedMusicVolume = _musicVolume
			_savedSoundVolume = _soundVolume
			setMusicVolume(0)
			setSoundVolume(0)
		else
			setMusicVolume(_savedMusicVolume)
			setSoundVolume(_savedSoundVolume)
		end
	end
end

--设置同时播放数量[1-23]--默认为23--
function setMaxNumSounds(num)
	if num < 1 or num > 23 then return false end
	AudioEngine:setMaxAudioInstance(num + 1)--加上背景音效
end

--停止所有音乐音效
function stopAll()
	AudioEngine:stopAll()
	_playingMusic = INVALID_AUDIO_ID
	_playingMusicPath = nil
	_playingSounds = {}
end

--暂停所有音乐音效
function pauseAll()
	AudioEngine:pauseAll()
end

--恢复所有音乐音效
function resumeAll()
	AudioEngine:resumeAll()
end













