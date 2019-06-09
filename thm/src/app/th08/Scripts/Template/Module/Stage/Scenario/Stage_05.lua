--预先生成310个bullet
local EEntityType = GameDef.Stage.EEntityType
local EEnemyBulletType = GameDef.Stage.EEnemyBulletType
local EBatmanType = GameDef.Stage.EBatmanType
local ScenarioUtil = StageDefine.ScenarioUtil
StageDefine.StageEntityManager.expandEntity(EEntityType.EnemyBullet,EEnemyBulletType.BigJade,300)
return {
    {
        time = 1,
        callback  = function (sender,task)
            Scheduler.schedule(function(delay,times)
                StageDefine.StageEntityManager.createEnemyBullets(EEnemyBulletType.BigJade,1,function(index,entity)
                    local theta = 10*times*math.pi/180
                    local radius = 80
                    local initPosX = display.cx + radius * math.cos(theta)
                    local initPosY = display.cy + radius * math.sin(theta)
                    local initSpeedX = 3 * math.cos(theta)
                    local initSpeedY = 3 * math.sin(theta)
                    local actions = {
                        cc.DelayTime:create(2),
                        cc.CallFunc:create(function()
                            entity:getComponent("RigidbodyComponent"):setSpeed(0,0)
                        end),
                        cc.MoveTo:create(2,cc.p(display.cx,display.cy)),
                        cc.CallFunc:create(function() entity:destroy() end),
                    }
                    return cc.p(initPosX,initPosY),cc.p(initSpeedX,initSpeedY),cc.Sequence:create(actions)
                end)
            end,0.08,10/0.08)
        end
    },


    {
        time = 10,
        callback  = function (sender,task)
            Scheduler.schedule(function(delay,times)
                StageDefine.StageEntityManager.createEnemyBullets(EEnemyBulletType.BigJade,1,function(index,entity)
                    local theta = 10*times*math.pi/180
                    local initPosX = display.cx + math.pow(2.71828,theta) * math.cos(theta)
                    local initPosY = display.cy + math.pow(2.71828,theta) * math.sin(theta)
                    local initSpeedX = 3 * math.cos(theta)
                    local initSpeedY = 3 * math.sin(theta)
                    local actions = {
                        cc.DelayTime:create(2),
                        cc.CallFunc:create(function()
                            entity:getComponent("RigidbodyComponent"):setSpeed(0,0)
                        end),
                        cc.MoveTo:create(2,cc.p(display.cx,display.cy)),
                        cc.CallFunc:create(function() entity:destroy() end),
                    }
                    return cc.p(initPosX,initPosY),cc.p(initSpeedX,initSpeedY),cc.Sequence:create(actions)
                end)
            end,0.08,10/0.08)
        end
    },

    {
        time = 15,
        callback  = function (sender,task)
            Scheduler.schedule(function(delay,times)
                StageDefine.StageEntityManager.createEnemyBullets(EEnemyBulletType.BigJade,1,function(index,entity)
                    local aTime = 0
                    local actions = {
                        cc.CallFunc:create(function()
                            aTime = aTime + 0.5
                            entity:setPosition(display.cx + 100 * math.cos(10*aTime*math.pi/180),3*aTime)
                        end),
                        cc.DelayTime:create(0.01),
                    }
                    return cc.p(0,0),cc.p(0,0),cc.RepeatForever:create(cc.Sequence:create(actions))
                end)
            end,0.08,3/0.08)
        end
    },
   
}