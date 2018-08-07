module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()
    --载入plist
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Assets/Texture/dragon.plist")
    -- display.loadSpriteFrames("Assets/Texture/Dragon.plist","Assets/Texture/dragon.png")

    local function createFrame(source,length, isReversed)
        local frames = {}
        local step = 1
        local begin = 1
        local last = begin + length - 1
        if isReversed then
            last, begin = begin, last
            step = -1
        end

        local texture
        local textureSize
        local startPos = {x=0,y=0}
        if type(source) == "string" then
            if string.byte(source) == 35 then -- first char is #
                --因为plist使用的纹理是一张大图,所以需要取得精灵
                local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrameByName(string.sub(source, 2))
                            
                if not spriteFrame then
                    error(string.format("display.newSpriteFrame() - invalid frame name \"%s\"", tostring(source)), 0)
                end
                
                local frameRect = spriteFrame:getRect()
                texture = spriteFrame:getTexture()
                textureSize = cc.size(frameRect.width,frameRect.height)
                startPos = cc.p(frameRect.x,frameRect.y)
            else
                texture = display.loadImage(source)
                textureSize = texture:getContentSize()
            end

        elseif tolua.type(source) == "cc.SpriteFrame" then
            local frameRect = source:getRect()
            texture = source:getTexture()
            textureSize = cc.size(frameRect.width,frameRect.height)
            startPos = cc.p(frameRect.x,frameRect.y)

        elseif tolua.type(source) == "cc.Texture2D" then
            texture = source
            textureSize = texture:getContentSize()
        else
            error("createFrame() - invalid parameters", 0)
        end

        
        local frameRect = cc.rect(startPos.x,startPos.y,textureSize.width/length,textureSize.height)
        for index = begin, last, step do
            frameRect.x = startPos.x + frameRect.width * (index - 1)
            frameRect.y = startPos.y

            local frame = cc.SpriteFrame:createWithTexture(texture, frameRect)

            frames[#frames + 1] = frame
        end
        return frames
    end

    -----
    local sprite = display.newSprite()
    sprite:align(display.CENTER,display.cx,display.cy-60)
    sprite:addTo(layer)

    local frames = createFrame("Assets/Role/Dragon/drag_walk_down.png",8)
    local animation = display.newAnimation(frames,1/4)     --1s里面播放4帧
    sprite:playAnimationForever(animation)

    local sprite = display.newSprite()
    sprite:align(display.CENTER,display.cx,display.cy+60)
    sprite:addTo(layer)

    local frames = createFrame("Assets/Role/Dragon/drag_walk_up.png",8)
    local animation = display.newAnimation(frames,1/4)     --1s里面播放4帧
    sprite:playAnimationForever(animation)

    ----

    local sprite = display.newSprite()
    sprite:align(display.CENTER,display.cx-60,display.cy)
    sprite:addTo(layer)
    local frames = display.newFrames("drag_walk_left_%02d.png",1,8)
    local animation = display.newAnimation(frames,1/8)     --1s里面播放4帧
    sprite:playAnimationForever(animation)

    --
    local sprite = display.newSprite()
    sprite:align(display.CENTER,display.cx+60,display.cy)
    sprite:addTo(layer)
    local frames = display.newFrames("drag_walk_right_%02d.png",1,8)
    local animation = display.newAnimation(frames,1/8)     --1s里面播放4帧
    sprite:playAnimationForever(animation)

    return layer
end
return M