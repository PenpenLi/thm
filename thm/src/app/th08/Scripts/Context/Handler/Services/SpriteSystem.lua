local M = {}
local DBXManager = THSTG.ANIMATION.DBXManager

function M.loadDBXFile(texSrc) DBXManager.loadDBXFile(texSrc) end
function M.loadPlistFile(plistPath)
    return THSTG.SCENE.loadPlistFile(plistPath)
end

function M.createTexture(altasName,frameName)
    local texture = TextureCache.get({altasName,frameName})
    if not texture then
		texture = DBXManager.createTexture(altasName,frameName)
        if not texture then return nil end
        
        TextureCache.add({altasName,frameName},texture)
    end
    return frame
end

function M.createFrame(altasName,frameName)
    local frame = SpriteFrameCache.get({altasName,frameName})
    if not frame then
		frame = DBXManager.createFrame(altasName,frameName)
        if not frame then return nil end
        
        SpriteFrameCache.add({altasName,frameName},frame)
    end
    return frame
end

function M.getAtlas(...) return DBXManager.getAtlas(...) end

return M