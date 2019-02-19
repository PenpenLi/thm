module(..., package.seeall)
--TODO:
local _bossEntity = nil
local _playerEntity = nil
local _enemyBullet = {}
local _playerBuller = {}

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
function setPlayerEntity(entity)
    _playerEntity = entity
end

function getPlayerEntity()
    return _playerEntity
end

------
function createEntity(class)
    
end

---
function createBullet(type)
    --读取配置,设置配置等
    --设置setAcitve()
end

function createBullets(type,num)

end

---
function createBatman(type)

end

function createBatmans(type,num)
    
end
-----

function createProp(type)

end

function createProps(type,num)
    
end