module("ScenePublic", package.seeall)

function newAnimation(texType,resName,time)
    local info = ResManager.getAnimationRes(texType,resName)
    if texType == TexType.SHEET then
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

function newAnimationBySheet(resName,time)
    return newAnimation(TexType.SHEET,resName,time)
end

function newAnimationByPlist(resName)
    return newAnimation(TexType.PLIST,resName,time)
end

function newAnimationByFiles(resName)
    return newAnimation(TexType.IMAGE,resName,time)
end