module("ScenePublic", package.seeall)

function newAnimation(params)
    params = params or {}
    ----
    local time = params.time or Definition.Public.ANIMATION_INTERVAL or 1/info.length
    if params.texType == TexType.SHEET then
        local info = SheetConfig.getSequence(params.fileName,params.resName)
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesBySheet({
                source = info.source,
                length = info.length,
                rect = info.rect,
            }),
            time = time ,
        })
        return animation
    elseif params.texType == TexType.PLIST then
        local info = PlistConfig.getSequence(params.fileName,params.resName)
        THSTG.SCENE.loadPlistFile(info.source)
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesByPattern({
                pattern = info.pattern,
                begin = info.begin,
                length = info.length,
            }),
            time = time,
        })
        return animation
    elseif params.texType == TexType.IMAGE then
        local info = ImageConfig.getSequence(params.fileName,params.resName)
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesByFiles({
                array = info.array,
                begin = info.begin,
                length = info.length,
            }),
            time = time,
        })
        return animation
    end

end

function newAnimationBySheet(fileName,resName,time)
    return newAnimation({
        texType = TexType.SHEET,
        fileName = fileName,
        resName = resName,
        time = time,
    })
end

function newAnimationByPlist(fileName,resName,time)
    return newAnimation({
        texType = TexType.PLIST,
        fileName = fileName,
        resName = resName,
        time = time,
    })
end

function newAnimationByFiles(fileName,resName,time)
    return newAnimation({
        texType = TexType.IMAGE,
        fileName = fileName,
        resName = resName,
        time = time,
    })
end