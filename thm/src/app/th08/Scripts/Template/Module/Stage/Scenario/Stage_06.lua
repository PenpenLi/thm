--预先生成310个bullet
local EEntityType = GameDef.Stage.EEntityType
local ScenarioUtil = StageDefine.ScenarioUtil
-- EntityManager.expandEntity(EEntityType.EnemyBullet,EEnemyBulletType.BigJade,300)
return {
    -- {
    --     time = 1,
    --     callback  = function (sender,task)
    --         Scheduler.schedule(function(delay,times)
    --             ScenarioUtil.takeEnemyBullets(1604,1,function(index,entity)
    --                 local theta = 10*times*math.pi/180
    --                 local radius = 80
    --                 local initPosX = display.cx + radius * math.cos(theta)
    --                 local initPosY = display.cy + radius * math.sin(theta)
    --                 local initSpeedX = 3 * math.cos(theta)
    --                 local initSpeedY = 3 * math.sin(theta)
    --                 local actions = {
    --                     cc.DelayTime:create(2),
    --                     cc.CallFunc:create(function()
    --                         entity:getComponent("RigidbodyComponent"):setSpeed(0,0)
    --                     end),
    --                     cc.MoveTo:create(2,cc.p(display.cx,display.cy)),
    --                     cc.CallFunc:create(function() entity:destroy() end),
    --                 }
    --                 return cc.p(initPosX,initPosY),cc.p(initSpeedX,initSpeedY),cc.Sequence:create(actions)
    --             end)
    --         end,0.08,10/0.08)
    --     end
    -- },

}