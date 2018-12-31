module(..., package.seeall)
local M = class("CollisionSystem",THSTG.ECS.System)
--[[
    网格碰撞思路:
    当物体发生移动,应该实时改变物体所在的区域,以便能快速找到

]]
-----
--通过坐标获取网格ID
local _GRID_SIZE_ = cc.size(50,50)
local _GRID_NUM_ = cc.p(13,13)
local _gridComps = {}
local _gridIDs = {}
local function getGridId(rect)
    local x = math.floor(rect.x / _GRID_SIZE_.width) + 1
    local y = math.floor(rect.y / _GRID_SIZE_.height)

    return (y * _GRID_NUM_.y + x)
end

local function updateGrids(comp,rect)
    local gridId = _gridIDs[comp] or -1

    _gridComps[gridId] = _gridComps[gridId] or {}
    _gridComps[gridId][comp] = nil
    gridId = getGridId(rect)
    _gridComps[gridId] = _gridComps[gridId] or {}
    _gridComps[gridId][comp] = comp
    
    _gridIDs[comp] = gridId
end

local function removeGridObjs(comp)
    local gridId = _gridIDs[comp]
    if gridId then
        _gridComps[gridId][comp] = nil
    end
end

-----
function M:getGridCompId(comp)
    return _gridIDs[comp]
end

function M:getGridComps(id)
    return _gridComps[id] or {}
end
-----
function M:_onInit()
    --消息注册
end

function M:_onUpdate(delay)
    local collComps = self:getComponents("ColliderComponent")
    for _,v in pairs(collComps) do
        local rect = v:getRect()
        updateGrids(v,rect)
    end
end

function M:_onEvent(e,params)
    if e == THSTG.ECSManager.EEventType.DestroyEntity then
        local entity = params
        local collComps = entity:getComponents("ColliderComponent")
        for k,v in pairs(collComps) do
            removeGridObjs(v)
        end
    end
end

return M