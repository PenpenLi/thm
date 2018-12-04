module(..., package.seeall)

-- 设置项列表，s需要明写是为了防止后期增加项时不按顺序来将导致整个数据错乱的问题
-- c：客户端key
-- s：服务端key,值为0时表示不保存到服务端
-- v：默认值，如果是数字需使用整数
-- kind：类别 1-基础数据  2-按键数据  

KEY_LIST = {
	--基础设置相关
    { c = "fullScreen", s = 0, v = false, kind = 1 },               --是否全屏
    { c = "verticalSync", s = 0, v = false, kind = 1 },             --是否垂直同步
    { c = "musicVolume", s = 0, v = 30, kind = 1 },                 --音乐音量
    { c = "soundVolume", s = 0, v = 30, kind = 1 },                 --声音音量

    { c = "fire", s = 0, v = "z", kind = 2 },                       --
    { c = "bomb", s = 0, v = "x", kind = 2 },                       --
    

}

local _ckeyDict = {}
local _skeyDict = {}

for k, v in ipairs(KEY_LIST) do
	if _ckeyDict[v.c] then
		error("KEY_LIST配置中'c'字段存在同名项:"..v.c)
	end
	_ckeyDict[v.c] = v

	if v.s ~= 0 then
		if _skeyDict[v.s] then
			error("KEY_LIST配置中's'字段存在同名项:"..v.s)
		end
		_skeyDict[v.s] = v
	end
end

--判断某个key是否存在
function isCKeyExist(ckey)
	return _ckeyDict[ckey] ~= nil
end

----------
--获取某个字段的默认值
function getDefaultValueByCKey(ckey)
	local t = _ckeyDict[ckey]
	if t then
		return t.v
	end
end