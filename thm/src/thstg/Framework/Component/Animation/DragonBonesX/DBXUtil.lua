module("DBXUtil", package.seeall)

function getDirPath(fullPath)
    local fileName = FileUtil.stripPath(fullPath)
    local dir = string.sub(fullPath,1,string.find(fullPath,fileName) - 2)
    return dir
end

function loadDBXFile(path)
    if path ~= "" then
        local filePath =  cc.FileUtils:getInstance():fullPathForFilename(path)
        local f = io.open( filePath, "r" )
        local t = f:read( "*all" )
        f:close()

        return t
    end
    return false
end

function parseTextureMap(jsonStr)
    local oriTb = {}
    if nil ~= jsonStr and "" ~= jsonStr then
        local texTb = json.decode(jsonStr)
        if texTb then
            local subTexture = texTb.SubTexture
            local newSubTexture = {}
            for i,v in ipairs(subTexture) do
                newSubTexture[v.name] = newSubTexture[v.name] or {}
                newSubTexture = v
            end
            oriTb = subTexture
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