local DBXUtil = "thstg.Framework.Component.Animation.DBX.DBXUtil"
local M = class("DBXAtlas")

function M:ctor(path)
    self._oriInfo = false
    self._texture = false

    self:load(path)
end

function M:load(path)
    local jsonStr = DBXUtil.loadDBXFile(path)
    self._oriInfo = DBXUtil.parseTextureMap(jsonStr)

    if self._oriInfo then
        local textureName = self:getAtlasPath()
        if textureName ~= "" then
            self:_loadTexture(path,textureName)
        end
    end

end

function M:getAtlasName()
    if self._oriInfo then
        return cc.size(self._oriInfo.player00)
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
        return cc.size(self._oriInfo.imagePath)
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
        return cc.size(info.frameWidth,info.frameHeight)
    end
    return cc.size(0,0)
end

function M:getFramePos(name)
    local info = self:getFrameInfos(name)
    if info then
        return cc.size(info.x,info.y)
    end
    return cc.size(0,0)
end

---
function M:createTexture(name)
   --TODO:
end

function M:createFrame(name)
    local info = self:getFrameInfos(name)
    if info then
        local rect = cc.rect(info.x,info.y,info.frameWidth,info.frameHeight)
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
end


return M

