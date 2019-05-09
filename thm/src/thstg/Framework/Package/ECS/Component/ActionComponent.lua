local M = class("ActionComponent",ECS.Component)

function M:_onInit()
    self._action = false
end

function M:runTimes(list,times)
    if list then
        if type(list) ~= "table" then
            list = {list}
        end

        if times < 0 then
            self._action = cc.RepeatForever:create(cc.Sequence:create(list))
            self:getEntity():runAction(self._action)
            return self._action
        elseif times > 0 then
            local array = {}
            for i = 1, times do table.insert(array, cc.Sequence:create(list)) end
            self._action = cc.Sequence:create(array)
            self:getEntity():runAction(self._action)
            return self._action
        end
    end
end

function M:runOnce(list)
    return self:runTimes(list,1)
end

function M:runForever(list)
    return self:runTimes(list,-1)
end

function M:runCustom(action)
    self:getEntity():runAction(action)
    self._action = action 
end

function M:stop()
    self:getEntity():stopAllActions()
    self._action = false

    -- if self._action then
    --     if not tolua.isnull(self._action) then
    --         self:getEntity():stopAction(self._action)
    --         self._action = false
    --     end
    -- end
end

----
function M:_onAdded(entity)
    local transComp = entity:getComponent("TransformComponent")
    assert(transComp, string.format("[%s] You must have a TransformComponent ",M.__cname))    
end

function M:_onRemoved(entity)
    
end




return M