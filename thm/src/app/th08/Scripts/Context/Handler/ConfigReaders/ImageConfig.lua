module("ImageConfig", package.seeall)
local IMAGE_PATH_PATTERN = "Scripts.Configs.Handwork.Image.%s"
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
    local plist = getDict(IMAGE_PATH_PATTERN,filename)
    local fileSrc = plist.source
    return plist.frame[keyName]
end

function getSequence(filename,keyName)
  -- TODO:
    return nil
end