
return {
    {
        time = 1,
        callback  = function (sender,task)
            --子弹测试,从中心绕圈发射弹幕
            local count = 0
            Scheduler.schedule(function()
                local bullet = StageDefine.EnemyBulletPrefab.new()
                local rigidComp = bullet:getComponent("RigidbodyComponent")
                local transComp = bullet:getComponent("TransformComponent")
                transComp:setPosition(display.cx,display.cy)
                local initX = 3 * math.cos(2*count*3.14/180)
                local initY = 3 * math.sin(2*count*3.14/180)
                rigidComp:setSpeed(initX,initY)
                bullet:setActive(true)
                count = count + 1
            end, 0.08,5/0.08)
        end
    },
    {
        time = 3,
        callback  = function (sender,task)
            --子弹测试,从中心绕圈发射弹幕
            Scheduler.schedule(function()
                for i = 1,45 do
                    local bullet = StageDefine.EnemyBulletPrefab.new()
                    local rigidComp = bullet:getComponent("RigidbodyComponent")
                    local transComp = bullet:getComponent("TransformComponent")
                    transComp:setPosition(display.cx,display.cy)
                    local initX = 1 * math.cos(8*i*3.14/180)
                    local initY = 1 * math.sin(8*i*3.14/180)
                    bullet:setActive(true)
                    rigidComp:setSpeed(initX,initY)
                end
            end, 2,5)
        end
    },
    {
        time = 15,
        callback  = function (sender,task)
            local count = 1
            math.randomseed(1001)  --伪随机数种子
            Scheduler.schedule(function()
                for i = 1,360,8 do
                    local bullet = StageDefine.EnemyBulletPrefab.new()
                    local rigidComp = bullet:getComponent("RigidbodyComponent")
                    local transComp = bullet:getComponent("TransformComponent")
                    local actionComp = bullet:getComponent("ActionComponent")
                    local angle = i  * (3.14/180)
                    local r = 60
                    local initPosX = display.cx + r * count * math.cos(angle)
                    local initPosY = display.cy + r * count * math.sin(angle)
                    transComp:setPosition(initPosX,initPosY)
                    actionComp:runOnce(cc.Sequence:create({
                        cc.DelayTime:create(2-count*0.2),
                        cc.CallFunc:create(function()
                            local speed = 1
                            
                            local shotAngle = math.random(0,6.28)
                            local initX = speed * math.cos(shotAngle)
                            local initY = speed * math.sin(shotAngle)
                            rigidComp:setSpeed(initX,initY)
                        end)
                    }))
                    rigidComp:setSpeed(0,0)
                    bullet:setActive(true)
                    
                end

                count = count + 1
            end, 0.2,3)
        end
    },

    {
        time = 20,
        callback  = function (sender,task)
            local count = 1
            Scheduler.schedule(function()
                for i = 225,315,5 do
                    local bullet = StageDefine.EnemyBulletPrefab.new()
                    local rigidComp = bullet:getComponent("RigidbodyComponent")
                    local transComp = bullet:getComponent("TransformComponent")
                    local actionComp = bullet:getComponent("ActionComponent")
                    local angle = i  * (3.14/180)
                    local r = 60
                    local initPosX = display.cx + r * count * math.cos(angle)
                    local initPosY = display.cy+display.cy/2 + r * count * math.sin(angle)
                    transComp:setPosition(initPosX,initPosY)
                    actionComp:runOnce(cc.Sequence:create({
                        cc.DelayTime:create(2-count*0.2),
                        cc.CallFunc:create(function()
                            local time = 0
                            actionComp:runOnce(cc.RepeatForever:create(cc.Sequence:create({
                                cc.DelayTime:create(0.01),
                                cc.CallFunc:create(function()
                                    --圆周运动,我写不出来...
                                    local speed = 1
                                    local initX = speed * math.sin(angle+time)
                                    local initY = speed * math.cos(angle+time)
                                    rigidComp:setSpeed(initX,initY)
                                    time = time + 0.01
                                    if time >= 5 then
                                        actionComp:stopAllActions()
                                    end
                                end)
                            })))
                        end)
                    }))
                    rigidComp:setSpeed(0,0)
                    bullet:setActive(true)
                    
                end

                count = count + 1
            end, 0.2,5)
        end
    },

    {
        time = 25,
        callback  = function (sender,task)
            --子弹测试,从中心绕圈发射弹幕
            local count = 0
            Scheduler.schedule(function()
                local bullet = StageDefine.EnemyBulletPrefab.new()
                local rigidComp = bullet:getComponent("RigidbodyComponent")
                local transComp = bullet:getComponent("TransformComponent")
                transComp:setPosition(display.cx,display.cy)
                local initX = 3 * math.cos(2*count*3.14/180)
                local initY = 3 * math.sin(2*count*3.14/180)
                rigidComp:setSpeed(initX,initY)
                bullet:setActive(true)
                count = count + 1
            end, 0.08,10/0.08)

            Scheduler.schedule(function()
                local bullet = StageDefine.EnemyBulletPrefab.new()
                local rigidComp = bullet:getComponent("RigidbodyComponent")
                local transComp = bullet:getComponent("TransformComponent")
                transComp:setPosition(display.cx,display.cy)
                local initX = 3 * math.cos(2*count*3.14/180 - 3.14)
                local initY = 3 * math.sin(2*count*3.14/180- 3.14)
                rigidComp:setSpeed(initX,initY)
                bullet:setActive(true)
                count = count + 1
            end, 0.08,10/0.08)
        end
    },
  
}