local DBXUtil = require "thstg.Framework.Component.Animation.DragonBonesX.DBXUtil"
local M = class("DBXAtlas")

function M:ctor(path)
    self._oriInfo = false
    self._texture = false

    self:load(path)
end

function M:load(path)
    local jsonStr = DBXUtil.loadJsonFile(path)
    self._oriInfo = DBXUtil.parseAtlasMap(jsonStr)

    if self._oriInfo then
        local textureName = self:getAtlasPath()
        if textureName ~= "" then
            self:_loadTexture(path,textureName)
        end
    end

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
        --TODO:当勾选"去除空白区域时的设置"
        if info.frameWidth and info.frameHeight then
            --被移除掉的留白尺寸
            -- local noneSize = cc.size(info.frameWidth - info.width,info.frameHeight - info.height)
            return cc.p(info.x, info.y)
        else
            return cc.p(info.x,info.y)
        end
    end
    return cc.p(0,0)
end

---
function M:createTexture(name)
   --TODO:
end

function M:createFrame(name)
    local info = self:getFrameInfos(name)
    if info then
        local pos = self:getFramePos(name)
        local size = self:getFrameSize(name)
        local rect = cc.rect(pos.x, pos.y, size.width, size.height)
        local frame = display.newSpriteFrame(self._texture,rect)
        return frame
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

