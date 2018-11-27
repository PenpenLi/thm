module("SheetConfig", package.seeall)

function getRes(resName,subName)
    local texture  = ResManager.getResSub(ResType.TEXTURE,TexType.PLIST,resName)
    THSTG.SCENE.loadPlistFile(texture)
    
	return subName
end
