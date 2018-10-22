module("FileUtil", package.seeall)

local fileUtils = cc.FileUtils:getInstance()

--获取路径
function stripFileName(filename)
	return string.match(filename, "(.+)/[^/]*%.%w+$") --*nix system
		--return string.match(filename, “(.+)\\[^\\]*%.%w+$”) — windows
end

--获取文件名
function stripPath(filename)
	return string.match(filename, ".+/([^/]*%.%w+)$") -- *nix system
end

--去除扩展名
function stripExtension(filename)
	local idx = filename:match(".+()%.%w+$")
	if(idx) then
		return filename:sub(1, idx-1)
	else
		return filename
	end
end

--获取扩展名
function getExtension(filename)
	return filename:match(".+%.(%w+)$")
end

function isFileExist(filename)
	return fileUtils:isFileExist(filename)
end

--[[
	读取指定文件内容
	@param   [string] fileName  指定文件路径（可写路径下的相对路径）
	@return  [string]           文件全部内容的字符串返回
--]]
function readWritableFileStrData(fileName)
	return FREngineUtil:getInstance():readWritableFileStrData(fileName)
end

--[[
	把内容写入指定文件, 原来文件内容将被覆盖
	@param  [string] fileName   指定文件路径（可写路径下的相对路径, 如果文件不存在将会被创建）
	@param  [string] contentStr 写入内容
	@return [boolean]           是否写入成功
--]]
function writeWritableFileStrData(fileName, contentStr)
	return FREngineUtil:getInstance():writeWritableFileStrData(fileName, contentStr)
end

--[[
	把内容追加到指定文件末尾, 原来文件内容将会保留
	@param  [string] fileName   指定文件路径（可写路径下的相对路径, 如果文件不存在将会被创建）
	@param  [string] contentStr 写入内容
	@return [boolean]           是否写入成功
--]]
function insertWritableFileStrData(fileName, contentStr)
	return FREngineUtil:getInstance():insertWritableFileStrData(fileName, contentStr)
end

--[[
	删除文件
	@param  [string] fileName   指定文件路径（可写路径下的相对路径）
	@return [boolean]           是否删除成功（文件不存在情况下返回true） 
--]]
function removeFile(fileName)
	return fileUtil:removeFile(string.format("%s%s", fileUtil:getWritablePath(), fileName))
end

--[[
	把源文件内容复制替换到指定文件，指定文件原来的内容将会被覆盖，指定文件不存在将会被创建
	@param  [string] sourceFileName     源文件路径（可写路径下的相对路径）
	@param  [string] replaceFileName    替换文件路径（可写路径下的相对路径）
	@return [boolean]                   是否替换成功
--]]
function replaceFile(sourceFileName, replaceFileName)
	sourceFileName = string.format("%s%s", cc.FileUtil:getWritablePath(), sourceFileName)
	replaceFileName = string.format("%s%s", cc.FileUtil:getWritablePath(), replaceFileName)
	return FREngineUtil:getInstance():replaceFile(sourceFileName, replaceFileName)
end

--检测某个路径下文件的md5是否与给定的一致
function checkFileMD5(fullFilePath, md5)
	if not isFileExist(fullFilePath) then
		return false
	else
		local fileMD5 = FRFileMD5(fullFilePath)
		if fileMD5 ~= "" and fileMD5 == md5 then
			return true
		else
			return false
		end
	end
end
