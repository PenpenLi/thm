module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()
    --载入plist
    cc.SpriteFrameCache:getInstance():addSpriteFrames(ResManager.getResMul(ResType.TEXTURE,TexType.PLIST,"dragon"))
    -- display.loadSpriteFrames("Assets/Texture/Dragon.plist","Assets/Texture/dragon.png")

    --FIXME:代码逻辑混乱
    local function createFrames(source, length, isReversed , isHorizonal)
        local frames = {}
        local step = 1
        local begin = 1
        local last = begin + length - 1
        if isReversed then
            last, begin = begin, last
            step = -1
        end

        local function loadTexture(scource)
            local texture = nil
            local texRect = nil

            if type(source) == "string" then
                if string.byte(source) == 35 then -- 第一个字符是 #
                    --因为plist使用的纹理是一张大图,所以需要取得精灵
                    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(string.sub(source, 2))    
                    if spriteFrame then
                        texRect = spriteFrame:getRect()
                        texture = spriteFrame:getTexture()
                    else
                        error(string.format("loadTexture() - invalid frame name \"%s\"", tostring(source)), 0)
                        return nil,nil
                    end
                else
                    texture = display.loadImage(source)
                    local textureSize = texture:getContentSize()
                    texRect = cc.rect(0,0,textureSize.width,textureSize.height)
                end
    
            elseif tolua.type(source) == "cc.SpriteFrame" then
                texRect = source:getRect()
                texture = source:getTexture()

            elseif tolua.type(source) == "cc.Texture2D" then
                texture = source
                local textureSize = texture:getContentSize()
                texRect = cc.rect(0,0,textureSize.width,textureSize.height)

            else
                error("createFrame() - invalid parameters", 0)
            end

            return texture,texRect
        end

        local texture,texRect = loadTexture(source)
        
        local frameSize = cc.size(texRect.width,texRect.height)
        if isHorizonal then
            frameSize.width = frameSize.width / length
        else
            frameSize.height = frameSize.height / length
        end
        
        local frameRect = cc.rect(texRect.x,texRect.y,frameSize.width,frameSize.height)
        for index = begin, last, step do
            if isHorizonal then
                frameRect.x = texRect.x + frameRect.width * (index - 1)
            else
                frameRect.y = texRect.y + frameRect.height * (index - 1)
            end
            
            local frame = cc.SpriteFrame:createWithTexture(texture, frameRect)

            frames[#frames + 1] = frame
        end
        return frames
    end

    --水平切割
    local function createHFrames(source, length, isReversed)
        return createFrames(source, length, isReversed,true)
    end
    --竖直切割
    local function createVFrames(source, length, isReversed)
        return createFrames(source, length, isReversed,false)
    end

    -----
    local sprite = display.newSprite()
    sprite:align(display.CENTER,display.cx,display.cy-60)
    sprite:addTo(layer)

    local frames = createHFrames(ResManager.getTexRes(TexType.SHEET,"dragon_walk_down"),8)
    local animation = display.newAnimation(frames,1/4)     --1s里面播放4帧
    sprite:playAnimationForever(animation)

    local sprite = display.newSprite()
    sprite:align(display.CENTER,display.cx,display.cy+60)
    sprite:addTo(layer)
    ----

    local sprite = display.newSprite()
    sprite:align(display.CENTER,display.cx-60,display.cy)
    sprite:addTo(layer)
    local frames = display.newFrames("drag_walk_left_%02d.png",1,8)
    local animation = display.newAnimation(frames,1/8)     --1s里面播放8帧
    sprite:playAnimationForever(animation)

    --
    local sprite = display.newSprite()
    sprite:align(display.CENTER,display.cx+60,display.cy)
    sprite:addTo(layer)
    local frames = display.newFrames("drag_walk_right_%02d.png",1,8)
    local animation = display.newAnimation(frames,1/8)     --1s里面播放8帧
    sprite:playAnimationForever(animation)



    -----------------------------
    --加载plist文件
    THSTG.SCENE.loadPlistFrames(ResManager.getResMul(ResType.TEXTURE,TexType.PLIST,"dragon"))

    local animationFrame = THSTG.SCENE.newFileFrames({
        pattern = "drag_walk_down_%02d.png",
        begin = 1,
        length = 8,
    })
    local animition = THSTG.SCENE.newAnimation({
        time = 1/8,
        frames = animationFrame ,
    })
    local animationSprite = THSTG.UI.newSprite({
        x = display.cx,
        y = display.cy +180,
        anchorPoint = THSTG.UI.POINT_CENTER,
    })
    layer:addChild(animationSprite)
    animationSprite:playAnimationForever(animition)


    local sprite = THSTG.UI.newSprite({
        x = 40,
        y = 40,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = "#drag_walk_down_01.png",
    })
    layer:addChild(sprite)

    return layer
end
return M