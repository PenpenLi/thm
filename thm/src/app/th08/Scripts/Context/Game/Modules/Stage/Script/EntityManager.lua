module(..., package.seeall)

local _bossEntity = nil
local _playerEntity = nil
function setBossEntity(entity)
    _bossEntity = entity
end
function getBossEntity()
    local bossEntitys = THSTG.ECSManager.findEntitiesByName("BOSS")
    if next(bossEntitys) then
        return bossEntitys[1]
    end
    return nil
end
function setPlayerEntity()
    
end
function getPlayerEntity()
    return _playerEntity
end

------
function newEntity(class)
    
end