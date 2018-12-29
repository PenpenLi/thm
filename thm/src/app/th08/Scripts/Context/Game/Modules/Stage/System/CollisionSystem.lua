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
local _compsIDs = {}
local function getGridId(rect)
    local x = math.floor(rect.x / _GRID_SIZE_.width) + 1
    local y = math.floor(rect.y / _GRID_SIZE_.height)

    return (y * _GRID_NUM_.y + x)
end

local function updateGridId(comp,rect)
    local gridId = _compsIDs[comp] or -1
    _gridComps[gridId] = _gridComps[gridId] or {}
    _gridComps[gridId][comp] = nil
    gridId = getGridId(rect)
    _gridComps[gridId] = _gridComps[gridId] or {}
    _gridComps[gridId][comp] = comp
    
    _compsIDs[comp] = gridId
end

--TODO:没有办法移除掉消亡的对象....
local function removeGridComp(comp)
    local gridId = _compsIDs[comp]
    if gridId then
        _gridComps[gridId][comp] = nil
    end
end

-----
function M:getGridId(v)
    return _compsIDs[v]
end

function M:getGridObjs(id)
    id = id or self:getGridId()
    return _gridComps[id]
end
-----
function M:_onInit()
    --消息注册
end

function M:_onUpdate(delay)
    --TODO:没有办法获得ColliderComponent,只能获得子类
    local collComps = self:getComponents("ColliderComponent")
    for _,v in pairs(collComps) do
        local rect = v:getRect()
        updateGridId(v,rect)
    end
end

return M