module("ScenePublic", package.seeall)

function newAnimation(texType,resName)
    local info = AnimationConfig.getRes(texType,resName)
    if texType == TexType.SHEET then
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesBySheet({
                source = info.source,
                length = info.length,
                rect = info.rect,
            }),
            time = info.time
        })
        return animation
    elseif texType == TexType.PLIST then
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesByPattern({
                pattern = info.pattern,
                begin = info.begin,
                length = info.length,
            }),
            time = info.time
        })
        return animation
    elseif texType == TexType.IMAGE then
        local animation = THSTG.SCENE.newAnimation({
            frames = THSTG.SCENE.newFramesByFiles({
                array = info.array,
                begin = info.begin,
                length = info.length,
            }),
            time = info.time
        })
        return animation
    end

end

function newAnimationBySheet(resName)
    return newAnimation(TexType.SHEET,resName)
end

function newAnimationByPlist(resName)
    return newAnimation(TexType.PLIST,resName)
end

function newAnimationByFiles(resName)
    return newAnimation(TexType.IMAGE,resName)
end