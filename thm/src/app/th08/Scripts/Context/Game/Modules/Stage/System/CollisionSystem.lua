module(..., package.seeall)
local M = class("CollisionSystem",THSTG.ECS.System)
--[[
    网格碰撞思路:
    当物体发生移动,应该实时改变物体所在的区域,以便能快速找到

]]
-----
--通过坐标获取网格ID
local _GRID_SIZE_ = cc.size(100,100)--FIXME:格子大小,决定碰撞检测的精度
local _GRID_NUM_ = cc.p(10,10)
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
    --当cript时序>System导致没有更新到位置出错
    if _gridIDs[comp] == nil then
        self:_onUpdate(0)
    end
    return _gridIDs[comp]
end

function M:getGridComps(id)
    return _gridComps[id] or {}
end
--周围4个
function M:getRound4GridIds(id)
    return {
        id, 
        id - 1, 
        id + 1, 
        id + _GRID_NUM_.y, 
        id - _GRID_NUM_.y
    }
end
--周围8个
function M:getRound8GridIds(id)
    return {
        id,
        id - 1, 
        id + 1, 
        id + _GRID_NUM_.y - 1 , 
        id + _GRID_NUM_.y, 
        id + _GRID_NUM_.y + 1,
        id - _GRID_NUM_.y - 1 , 
        id - _GRID_NUM_.y,
        id - _GRID_NUM_.y + 1,
    }
end
--左上
function M:getLeftTopGridIds(id)
    return {
        id,
        id - 1, 
        id + _GRID_NUM_.y - 1 , 
        id + _GRID_NUM_.y, 
        id + _GRID_NUM_.y + 1,
    }
end
--右下
function M:getRightBottomGridIds(id)
    return {
        id,
        id + 1, 
        id - _GRID_NUM_.y - 1 , 
        id - _GRID_NUM_.y,
        id - _GRID_NUM_.y + 1,
    }
end

function M:isCollidedByGrids(entity,filter,idsFunc)
    local myColliders = entity:getComponents("ColliderComponent")
    for _,v in pairs(myColliders) do
        local curId = self:getGridCompId(v)  --判断属于同一格的实体
        local ids = idsFunc and idsFunc(curId) or {curId}
        for _,compId in ipairs(ids) do  --应该判断4个方向的格子
            local otherComps = self:getGridComps(compId) --取得碰撞组件
            for _,vv in pairs(otherComps) do
                while true do
                    if v ~= vv then
                        if type(filter) == "table" then
                            local isBreak = false
                            for _,str in ipairs(filter) do  if vv:getEntity():getName() == str then isBreak = true  break end end
                            if isBreak then break end
                        elseif type(filter) == "function" then
                            if filter(vv:getEntity()) then  break  end
                        end

                        if v:collide(vv) then
                            --返回碰撞结果和信息
                            return true,{
                                collider = vv:getEntity()
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