module(..., package.seeall)

function getDirPath(fullPath)
    local fileName = FileUtil.stripPath(fullPath)
    local dir = string.sub(fullPath,1,string.find(fullPath,fileName) - 2)
    return dir
end

function loadJsonFile(path)
    if path and path ~= "" then
        local filePath =  cc.FileUtils:getInstance():fullPathForFilename(path)
        local f = io.open( filePath, "r" )
        local t = f:read( "*all" )
        f:close()

        return t
    end
    return false
end

function parseAtlasMap(jsonStr)
    local oriTb = {}
    if nil ~= jsonStr and "" ~= jsonStr then
        local atlasTb = json.decode(jsonStr)
        if atlasTb then
            local subTexture = atlasTb.SubTexture
            local newSubTexture = {}
            for i,v in ipairs(subTexture) do
                newSubTexture[v.name] = v
            end
            oriTb = atlasTb
            oriTb.SubTexture = newSubTexture

            return oriTb
        end
    end
    return false
end

function parseSkeletonMap(jsonStr)
    local oriTb = {}
    if nil ~= jsonStr and "" ~= jsonStr then
        local skeletonTb = json.decode(jsonStr)
        if skeletonTb then
            local armature = skeletonTb.armature
            local newArmature = {}
            for i,v in ipairs(armature) do
                newArmature[v.name] = v
            end
            oriTb = skeletonTb
            oriTb.armature = newArmature

            return oriTb
        end
    end
    return false
end