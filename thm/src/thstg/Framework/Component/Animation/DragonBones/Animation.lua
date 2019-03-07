
NodeAni = require "thstg.Framework.Component.UI.Basic.DragonBones.NodeAni"
--- 骨骼动画包装器
-- 建议最多包括2级嵌套动画
 
local Animation = {}
 
Animation.Z_ORDER_UPDATED = 0
Animation.ANIMATION_FRAME_EVENT = 1
Animation.BONE_FRAME_EVENT = 2
Animation.SOUND = 3
Animation.FADE_IN = 4
Animation.FADE_OUT = 5
Animation.START = 6
Animation.COMPLETE = 7
Animation.LOOP_COMPLETE = 8
Animation.FADE_IN_COMPLETE = 9
Animation.FADE_OUT_COMPLETE = 10
Animation._ERROR = 11
 
--- 创建一个动画并返回
-- @string fileName    动画名
-- @string armatureName 骨架名
-- @return NodeAni
function Animation.node(fileName, armatureName)
    return NodeAni.new(fileName, armatureName)
end
 
--- 删除已加载的指定名字的动画资源缓存
-- @string fileName 文件名
function Animation.removeRes(fileName)
    local factory = db.DBCCFactory:getInstance()
    local textureName = Animation.getTexturePng(fileName)
    factory:removeDragonBonesData(fileName)
    factory:removeTextureAtlas(fileName)
    --cocos2dx又换存了一次  需要清空否则 图片纹理不回收  实测
    TextureCache:removeTextureForKey(textureName)
end
 
--- 清空所有加载过的Ani资源
-- 全部卸载干净 一般用于游戏热更新后重启
function Animation.removeAllRes()
    local factory = db.DBCCFactory:getInstance()
    factory:dispose(true)
end
 
--- 返回指定名字的动画骨架XML
-- @string fileName 文件名
function Animation.getSkeletonXml(fileName)
    return "res/ani/" .. fileName .. "/skeleton.xml"
end
 
--- 返回指定名字的动画图片XML
-- @string fileName 文件名
function Animation.getTextureXml(fileName)
    return "res/ani/" .. fileName .. "/texture.xml"
end
 
--- 返回指定名字的动画图片png
-- @string fileName 文件名
function Animation.getTexturePng(fileName)
    return "res/ani/" .. fileName .. "/texture.png"
end
 
return Animation