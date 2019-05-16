module(..., package.seeall)
local DBXManager = ANIMATION.DBXManager

function loadFile( ... ) return DBXManager.loadDBXFile(...) end
function createTexture(...) return DBXManager.createTexture(...) end
function createFrame(...) return DBXManager.createFrame(...) end
function createFrames(...) return DBXManager.createFrames(...) end
function createAnimation(...) return DBXManager.createAnimation(...) end
function createAnimate(...) return DBXManager.createAnimate(...) end
function createAnime(...) return DBXManager.createAnime(...) end

function getAtlas(...) return DBXManager.getAtlas(...) end
function getSkeleton(...) return DBXManager.getSkeleton(...) end

function clear( ... )

end