module("PlistConfig", package.seeall)

local PLIST_PATH_PATTERN = "Scripts.Configs.Handwork.Plist.%s"
local _dict = {}
local _animDict = {}
local function getDictByFile(path,file)
    local pathFile = string.format(path,file)

    if _dict[pathFile] then return _dict[pathFile]
    else
        local fileTb = require(pathFile)
        if fileTb then
            _dict[pathFile] = fileTb
        end
        return fileTb
    end

    return nil
end

local function getDict(filename)
    local tb = getDictByFile(SHEET_PATH_PATTERN,filename)
    return tb
end

function getFrame(filename,keyName)
    local plist = getDict(PLIST_PATH_PATTERN,filename)
    local fileSrc = plist.source
    return plist.frame[keyName]
end

function getSequence(filename,keyName)
    if _animDict[filename] and _animDict[filename][keyName] then
        return _animDict[filename][keyName]
    else

        local plist = getDict(PLIST_PATH_PATTERN,filename)
        local fileSrc = plist.source
        local info = plist.sequence[keyName]
        if info then
            _animDict[filename] = _animDict[filename] or {}

            local ret = clone(info.info)
            ret.source = fileSrc

            _animDict[filename][keyName] = ret
            return ret
        end
    end
    return nil
end

