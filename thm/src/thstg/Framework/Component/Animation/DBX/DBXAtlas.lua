local DBXUtil = require "thstg.Framework.Component.Animation.DBX.DBXUtil"
local M = class("DBXAtlas")

function M:ctor(path)
    self._oriInfo = false
    self._texture = false

    self:load(path)
end

function M:load(path)
    if not path or path == "" then return false end

    local jsonStr = DBXUtil.loadJsonFile(path)
    self._oriInfo = DBXUtil.parseAtlasMap(jsonStr)

    if self._oriInfo then
        local textureName = self:getAtlasPath()
        if textureName ~= "" then
            self:_loadTexture(path,textureName)
        end
        return true
    end
    return false
end

function M:getAtlasName()
    if self._oriInfo then
        return self._oriInfo.name
    end
    return ""
end

function M:getAtlaseSize()
    local size = cc.size(0,0)
    if self._oriInfo then
        return cc.size(self._oriInfo.width,self._oriInfo.height)
    end

    return size
end

function M:getAtlasPath()
    if self._oriInfo then
        return self._oriInfo.imagePath
    end
    return ""
end

function M:getFrameInfos(name)
    if self._oriInfo then
        return self._oriInfo.SubTexture and self._oriInfo.SubTexture[name]
    end
    return nil
end

function M:getFrameSize(name)
    local info = self:getFrameInfos(name)
    if info then
        return cc.size(info.width,info.height)
    end
    return cc.size(0,0)
end

function M:getFramePos(name)
    local info = self:getFrameInfos(name)
    if info then
        return cc.p(info.x,info.y)
    end
    return cc.p(0,0)
end

---
--TODO:好像没用
function M:createTexture(name)
    local frame = self:createFrame(name)
    local sprite = cc.Sprite:createWithSpriteFrame(frame)
    sprite:setAnchorPoint(cc.p(0.5,0.5))
    sprite:setPosition(sprite:getContentSize().width/2,sprite:getContentSize().height/2)
    sprite:setFlippedY(true)
    
    local render = cc.RenderTexture:create(sprite:getContentSize().width, sprite:getContentSize().height)
	render:beginWithClear(0,0,0,0)
    sprite:visit()
    render:endToLua()
    
    return render:getSprite():getTexture()
end

function M:createFrame(name)
    local info = self:getFrameInfos(name)
    if info then
        local texRect = cc.rect(info.x, info.y, info.width, info.height)
        --当勾选"去除空白区域时的设置"
        if info.frameWidth and info.frameHeight then
            local frame = display.newSpriteFrame(self._texture,texRect,false,cc.p(info.frameX,info.frameY),cc.size(info.frameWidth,info.frameHeight))
            return frame
        else
            local frame = display.newSpriteFrame(self._texture,texRect)
            return frame
        end
    end
    return nil
end
-----
function M:_loadTexture(path,textureName)
    local dirPath = DBXUtil.getDirPath(path)
    local srcPath = string.format("%s/%s",dirPath,textureName)
    self._texture = display.loadImage(srcPath)-- 加载纹理文件
    assert(self._texture,string.format( "[DBXAtlas]:Texture file not find(%s)",srcPath))
end


return M

