module("SheetConfig", package.seeall)
local SHEET_PATH_FILES = "Scripts.Configs.Handwork.Sheet.All"
local SHEET_PATH_PATTERN = "Scripts.Configs.Handwork.Sheet.%s"
local EType = {
    Frame = 1,
    Sequence = 2,
}
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
    if _animDict[filename] and _animDict[filename][EType.Frame] and _animDict[filename][EType.Frame][keyName] then
        return _animDict[filename][EType.Frame][keyName]
    else
        local sheet = getDict(filename)
        local fileSrc = sheet.source
        local info = sheet.frame[keyName]
        if info then
            _animDict[filename] = _animDict[filename] or {}
            _animDict[filename][EType.Frame] = _animDict[filename][EType.Frame] or {}
            
            local ret = clone(info.grid)
            ret.source = fileSrc

            _animDict[filename][EType.Frame][keyName] = ret
            return ret
        end
    end
    return nil
end

local _frameDict = false
function getFrameDict(filename)
    if not _frameDict then
        _frameDict = {}
        local files = {}
        if filename then files = {filename} else files = require(SHEET_PATH_FILES) end
        for _,v in pairs(files) do
            local tb = getDict(v)
            if tb and tb.frame then
                _frameDict[v] = _frameDict[v] or {}
                for keyName,_ in pairs(tb.frame) do 
                    _frameDict[v][keyName] = getFrame(v,keyName)
                end
            end
        end
    end
    return _frameDict
end

function getSequence(filename,keyName)
    if _animDict[filename] and _animDict[filename][EType.Sequence] and _animDict[filename][EType.Sequence][keyName] then
        return _animDict[filename][EType.Sequence][keyName]
    else
        local sheet = getDict(filename)
        local fileSrc = sheet.source
        local info = sheet.sequence[keyName]
        if info then
            _animDict[filename] = _animDict[filename] or {}
            _animDict[filename][EType.Sequence] = _animDict[filename][EType.Sequence] or {}

            local ret = clone(info.grid)
            ret.source = fileSrc

            _animDict[filename][EType.Sequence][keyName] = ret
            return ret
        end
    end
    return nil
end

local _sequenceDict = false
function getSequenceDict(filename)
    if not _sequenceDict then
        _sequenceDict = {}
        local files = {}
        if filename then files = {filename} else  files = require(SHEET_PATH_FILES) end
        for _,v in ipairs(files) do
            local tb = getDict(v)
            if tb and tb.sequence then
                _sequenceDict[v] = _sequenceDict[v] or {}
                for keyName,_ in pairs(tb.sequence) do 
                    _sequenceDict[v][keyName] = getSequence(v,keyName)
                end
            end
        end
    end
    return _sequenceDict
end

