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
        time = 1,
        callback  = function (sender,task)
            local actions = {}
            table.insert(actions, cc.MoveTo:create(2.0,cc.p(display.cx,display.cy+100)))  
    
            local actionComp = curBoss:getComponent("ActionComponent")
            actionComp:runAction(cc.Sequence:create(actions))
        end
    },

    {
        time = 5,
        callback  = function (sender,task)
           
            local actions = {}
            table.insert(actions, cc.MoveBy:create(1.0,cc.p(-200,0)))  
            
            local actionComp = curBoss:getComponent("ActionComponent")
            actionComp:runAction(cc.Sequence:create(actions))
        end
    },

    {
        time = 10,
        callback  = function (sender,task)
           
            local actions = {}
            table.insert(actions, cc.MoveBy:create(1.0,cc.p(100,-200)))  
            
            local actionComp = curBoss:getComponent("ActionComponent")
            actionComp:runAction(cc.Sequence:create(actions))
        end
    },

    {
        time = 8,
        callback  = function (sender,task)
            --回到1秒前执行
        end
    },

}