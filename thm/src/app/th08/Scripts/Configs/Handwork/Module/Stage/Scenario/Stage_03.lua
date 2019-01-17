local layer = THSTG.SceneManager.get(SceneType.STAGE).entityLayer
local curBoss = nil
return {
    {
        time = 0,
        callback  = function (sender,task,params)
            curBoss = StageDefine.Boss.new()
            local posComp = curBoss:getComponent("TransformComponent")
            posComp:setPositionX(40)
            posComp:setPositionY(display.width + 100)
            layer:addChild(curBoss)

        end
    },

    {
        time = 0,
        callback  = function (sender,task)
            local actions = {
                cc.MoveTo:create(2.0,cc.p(display.cx,display.cy+100))
            }

            local actionComp = curBoss:getComponent("ActionComponent")
            actionComp:runAction(cc.Sequence:create(actions))
        end
    },

    {
        time = 2,
        callback  = function (sender,task)
            local actions = {
                cc.DelayTime:create(2),
                cc.MoveBy:create(1.0,cc.p(-200,0)),
                cc.DelayTime:create(2),
                cc.MoveBy:create(1.0,cc.p(300,100)),
                cc.DelayTime:create(2),
                cc.MoveBy:create(1.0,cc.p(-200,0)),
                cc.DelayTime:create(2),
                cc.MoveTo:create(2.0,cc.p(display.cx,display.cy+100)),
                cc.DelayTime:create(2),
            }
            local actionComp = curBoss:getComponent("ActionComponent")
            actionComp:runAction(cc.RepeatForever:create(cc.Sequence:create(actions)))
        end
    },

   

}