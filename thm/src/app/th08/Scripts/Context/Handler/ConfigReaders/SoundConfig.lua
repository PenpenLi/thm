module("SoundConfig", package.seeall)
local FileUtils = cc.FileUtils:getInstance()

local _dict = nil
local function getDict()
	if not _dict then
		_dict = require "Scripts.Configs.Handwork.H_Sounds"
	end
	return _dict
end

function hasVoice(musicKey)
	return getDict()[musicKey]
end

function getFilePath(soundKey)
	local t = getDict()[soundKey]
	if t then
		return t.src
	end

	return false
end