--预先生成310个bullet
local EEntityType = GameDef.Stage.EEntityType
local ScenarioUtil = StageDefine.ScenarioUtil
EntityManager.expandEntity(EEntityType.EnemyBullet,0,70)
return {
    {
        time = 1,
        callback  = function (sender,task)
            ScenarioUtil.takeBoss(1,1,function(index,entity)
                local initPosX = display.cx
                local initPosY = display.cy
                local initSpeedX = 0
                local initSpeedY = 0
                return cc.p(initPosX,initPosY),cc.p(initSpeedX,initSpeedY)
            end)
        end
    },

    -- {
    --     time = 1,
    --     callback  = function (sender,task)
    --         Scheduler.schedule(function(delay,times)
    --             ScenarioUtil.takeEnemyBullets(804,1,function(index,entity)
    --                 local theta = 10*times*math.pi/180
    --                 local radius = 80
    --                 local initPosX = display.cx + radius * math.cos(theta)
    --                 local initPosY = display.cy + radius * math.sin(theta)
    --                 local initSpeedX = 3 * math.cos(theta)
    --                 local initSpeedY = 3 * math.sin(theta)
    --                 local actions = {
    --                     cc.DelayTime:create(2),
    --                     cc.CallFunc:create(function()
    --                         entity.RigidbodyComponent:setSpeed(0,0)
    --                     end),
    --                     cc.MoveTo:create(2,cc.p(display.cx,display.cy)),
    --                     cc.CallFunc:create(function() entity:destroy() end),
    --                 }
    --                 return cc.p(initPosX,initPosY),cc.p(initSpeedX,initSpeedY),cc.Sequence:create(actions)
    --             end)
    --         end,0.08,10/0.08)
    --     end
    -- },
    -- {
    --     time = 11,
    --     callback  = function (sender,task)
    --         math.randomseed(1001)  --伪随机数种子
    --         Scheduler.schedule(function(delay,times)
    --             ScenarioUtil.takeEnemyBullets(804,360/30,function(index,entity)
    --                 local angle = index *360/8 * 0.01745
    --                 local r = 60
    --                 local initPosX = display.cx + r * times * math.cos(angle)
    --                 local initPosY = display.cy + r * times * math.sin(angle)
    --                 local actions = {
    --                     cc.DelayTime:create(2-times*0.2),
    --                     cc.CallFunc:create(function()
    --                         local speed = 1
                            
    --                         local shotAngle = math.random(0,6.28)
    --                         local initX = speed * math.cos(shotAngle)
    --                         local initY = speed * math.sin(shotAngle)
    --                         entity.RigidbodyComponent:setSpeed(initX,initY)
    --                     end)
    --                 }
                    
    --                 return cc.p(initPosX,initPosY),cc.p(0,0),cc.Sequence:create(actions)
    --             end) 
    --         end, 0.2,3)
    --     end
    -- },
}