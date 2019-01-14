module("SoundConfig", package.seeall)
local FileUtils = cc.FileUtils:getInstance()

local _dict = nil
local function getDict()
	if not _dict then
		_dict = require "Configs.Handwork.Sounds"
	end
	return _dict
end

function hasVoice(musicKey)
	return getDict()[musicKey]
end

local function getFilePath(soundKey)
	local t = getDict()[soundKey]
	if t then
		return t.src
	end

	return false
end