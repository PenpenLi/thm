module("ScenePublic", package.seeall)

function newAnimation(texType,fileName,resName,time)

    if texType == TexType.SHEET then
        local info = SheetConfig.getSequence(fileName,resName)
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesBySheet({
                source = info.source,
                length = info.length,
                rect = info.rect,
            }),
            time = time or 1/info.length
        })
        return animation
    elseif texType == TexType.PLIST then
        local info = PlistConfig.getSequence(fileName,resName)
        THSTG.SCENE.loadPlistFile(info.source)
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesByPattern({
                pattern = info.pattern,
                begin = info.begin,
                length = info.length,
            }),
            time = time or 1/info.length
        })
        return animation
    elseif texType == TexType.IMAGE then
        local info = ImageConfig.getSequence(fileName,resName)
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesByFiles({
                array = info.array,
                begin = info.begin,
                length = info.length,
            }),
            time = time or 1/info.length
        })
        return animation
    end

end

function newAnimationBySheet(fileName,resName,time)
    return newAnimation(TexType.SHEET,fileName,resName,time)
end

function newAnimationByPlist(fileName,resName,time)
    return newAnimation(TexType.PLIST,fileName,resName,time)
end

function newAnimationByFiles(fileName,resName,time)
    return newAnimation(TexType.IMAGE,fileName,resName,time)
end