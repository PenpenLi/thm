local M = class("GridsCollisionController",THSTG.ECS.Script)
--[[
    网格碰撞思路:
    当物体发生移动,应该实时改变物体所在的区域,以便能快速找到

]]
-----
--通过坐标获取网格ID
local _GRID_SIZE_ = cc.size(50,50)
local _GRID_NUM_ = cc.p(13,13)
local _gridEntity = {}
local function getGridId(rect)
    local x = math.floor(rect.x / _GRID_SIZE_.width) + 1
    local y = math.floor(rect.y / _GRID_SIZE_.height)

    return (y * _GRID_NUM_.y + x)
end

local function updateGridId(entity,gridId,rect)
    _gridEntity[gridId] = _gridEntity[gridId] or {}
    _gridEntity[gridId][entity] = nil
    gridId = getGridId(rect)
    _gridEntity[gridId] = _gridEntity[gridId] or {}
    _gridEntity[gridId][entity] = entity
    
    return gridId
end

local function removeGridObj(entity,gridId)
    _gridEntity[gridId][entity] = nil
end
-----
function M:_onInit()
    self._gridId = 1
end
----
function M:getGridId()
    return self._gridId
end

function M:getGridObjs(id)
    return _gridEntity[id]
end
----
function M:_onAdded(entity)
    self:_onLateUpdate(0,entity)
end

function M:_onRemoved(entity)
    removeGridObj(entity,self._gridId)
end

function M:_onUpdate(delay,entity)

end

function M:_onLateUpdate(delay,entity)
    local colliderComp = self:getComponent("ColliderComponent")
    if colliderComp then
        local rect = colliderComp:getRect()

        self._gridId = updateGridId(entity,self._gridId,rect)
    end
end


return M