module(..., package.seeall)
local STAGE_VIEW_SIZE = GameDef.Stage.STAGE_VIEW_SIZE
local M = class("CollisionSystem",THSTG.ECS.System)
M.EDirectionType = {
    None = 1,
    Left = 2,
    Right = 3,
    Up = 4,
    Down = 5,
    LeftTop = 6,
    RightTop = 7,
    LeftBottom = 8,
    RightBottom = 9,
}
--[[
    网格碰撞思路:
    当物体发生移动,应该实时改变物体所在的区域,以便能快速找到

]]
-----
--通过坐标获取网格ID
local _GRID_NUM_ = cc.p(8,6)
local _GRID_SIZE_ = cc.size(STAGE_VIEW_SIZE.width/_GRID_NUM_.x,STAGE_VIEW_SIZE.height/_GRID_NUM_.y)--XXX:格子大小,决定碰撞检测的精度(格子越大,碰撞检测越精确,但是耗能越大,反之亦然)
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
    --当Script时序>System导致没有更新到位置出错
    if _gridIDs[comp] == nil then
        self:_onUpdate(0)
    end
    return _gridIDs[comp]
end

function M:getGridComps(id)
    return _gridComps[id] or {}
end
--
function M:getCollisionGridIds(id,directions)
    local list = {}
    for i,v in ipairs(directions) do
        if v == M.EDirectionType.None then
            table.insert( list, id)
        elseif v == M.EDirectionType.Left then
            table.insert( list, id - 1)
        elseif v == M.EDirectionType.Right then
            table.insert( list, id + 1)
        elseif v == M.EDirectionType.Up then
            table.insert( list, id + _GRID_NUM_.y)
        elseif v == M.EDirectionType.Down then
            table.insert( list, id - _GRID_NUM_.y)
        elseif v == M.EDirectionType.LeftTop then
            table.insert( list, id + _GRID_NUM_.y - 1)
        elseif v == M.EDirectionType.RightTop then
            table.insert( list, id + _GRID_NUM_.y + 1)
        elseif v == M.EDirectionType.LeftBottom then
            table.insert( list, id - _GRID_NUM_.y - 1)
        elseif v == M.EDirectionType.RightBottom then
            table.insert( list, id - _GRID_NUM_.y + 1)
        end
    end
    return list
end
--自己
function M:getRoundMyGridIds(id)
    return getCollisionGridIds(id,{
        M.EDirectionType.None,

    })
end
--周围4个
function M:getRound4GridIds(id)
    return getCollisionGridIds(id,{
        M.EDirectionType.None,
        M.EDirectionType.Left,
        M.EDirectionType.Right,
        M.EDirectionType.Up,
        M.EDirectionType.Down,
    })
end
--周围8个
function M:getRound8GridIds(id)
    return getCollisionGridIds(id,{
        M.EDirectionType.None,
        M.EDirectionType.Left,
        M.EDirectionType.Right,
        M.EDirectionType.Up,
        M.EDirectionType.Down,

        M.EDirectionType.LeftTop,
        M.EDirectionType.RightTop,
        M.EDirectionType.LeftBottom,
        M.EDirectionType.RightBottom,
    })
end
--左上
function M:getLeftTopGridIds(id)
    return getCollisionGridIds(id,{
        M.EDirectionType.None,
        M.EDirectionType.Left,
        M.EDirectionType.LeftTop,
        M.EDirectionType.Up,
        M.EDirectionType.RightTop,
    })
end
--右下
function M:getRightBottomGridIds(id)
    return getCollisionGridIds(id,{
        M.EDirectionType.None,
        M.EDirectionType.Right,
        M.EDirectionType.Down,
        M.EDirectionType.LeftBottom,
        M.EDirectionType.RightBottom,
    })
end

function M:isCollidedByGrids(entity,filter,idsFunc)
    local myColliders = entity:getComponents("ColliderComponent")
    for _,v in pairs(myColliders) do
        local curId = self:getGridCompId(v)  --判断属于同一格的实体
        local ids = idsFunc and idsFunc(curId) or {curId}
        for _,compId in ipairs(ids) do  --应该判断n个方向的格子
            local otherComps = self:getGridComps(compId) --取得碰撞组件
            for _,vv in pairs(otherComps) do
                while true do
                    if not vv:getEntity():isActive() then break end
                    if v ~= vv then
                        if type(filter) == "table" then
                            local isBreak = false
                            local name = vv:getEntity():getName()
                            if type(filter.ignore) == "table" then
                                isBreak = false
                                if name and filter.ignore[name] then 
                                    isBreak = true
                                end
                            elseif type(filter.match) == "table" then
                                isBreak = true
                                if name and filter.match[name] then 
                                    isBreak = false
                                end
                            end
                            if isBreak then break end
                        elseif type(filter) == "function" then
                            if filter(vv:getEntity()) then  break  end
                        end

                        if v:collide(vv) then
                            --返回碰撞结果和信息
                            return true,{
                                collider = vv:getEntity(),
                                component = vv,
                            }
                        end
                    end
                    break
                end
            end
        end
    end
    return false,nil
end

function M:isCollided(entity,filter)
   return self:isCollidedByGrids(entity,filter)
end

-----
function M:_onInit()
    --消息注册
    THSTG.ECSManager.getDispatcher():addEventListener(THSTG.TYPES.ECSEVENT.ECS_ENTITY_REMOVED, self._entityRemoveHandle, self)
end

function M:_onUpdate(delay)
    local compsGroups = self:getGroups()
    for _,group in pairs(compsGroups) do
        local collComp = group.ColliderComponent
        local rect = collComp:getRect()
        updateGrids(collComp,rect)
    end
end

function M:_onLateUpdate()
    --越界判断更高效
    local compsGroups = self:getGroups()
    for _,group in pairs(compsGroups) do
        local colliderCtrl = group.CollisionController
        local filterStr = colliderCtrl:getFilter()
        local isCollision,collision = self:isCollidedByGrids(colliderCtrl:getEntity(),filterStr)
        if isCollision then
            colliderCtrl:collide(collision.collider,collision)
        end
    end
end

function M:_onFilter( ... )
    return {"ColliderComponent","CollisionController"}
end

----
function M:_entityRemoveHandle(e,entity)
    local collComps = entity:getComponents("ColliderComponent")
    for _,v in pairs(collComps) do
        removeGridObjs(v)
    end
end

return M