return {
    {
        time = 1,
        callback  = function (sender,task)
            local node = sender:getUserData().enemyLayer
            --左边生成三个小怪,并向下移动
            for i = 1,3 do
                local critter = THSTG.UI.newNode({
                    x = 40,
                    y = display.height - (i-1) * 60,
                    height = 40,
                    width = 40,
                    anchorPoint = THSTG.UI.POINT_LEFT_BOTTOM,
                })
                
                node:addChild(critter)
                debugUI(critter)

                local actions = {}
                table.insert(actions, cc.MoveBy:create(8.0,cc.p(0,-(2*display.height))))  
                table.insert(actions,cc.CallFunc:create(function ()
                    sender:resume()
                    critter:removeFromParent()
                    
                end))
                sender:pause()
                critter:runAction(cc.Sequence:create(actions))
            end
        end
    },
    {
        time = 12,
        callback  = function (sender)
            print(15,sender:time())
        end,
    },
    {
        time = 4,
        callback  = function (sender)
            print(15,sender:time())
        end,
    },
    {
        time = 4,
        callback = function (sender,task)
            local node = sender:getUserData().enemyLayer
            --从左往右
            for i = 1,6 do
                local critter = THSTG.UI.newNode({
                    x = 40 - i*60,
                    y = display.cy,
                    height = 40,
                    width = 40,
                    anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
                })
                critter:setPositionX(StageDef.ScenarioUtil.calculateBoundX(critter,i,10,false))
                node:addChild(critter)
                debugUI(critter)

                local actions = {}
                table.insert(actions, cc.MoveBy:create(8.0,cc.p((2*display.width),0)))
                table.insert(actions,cc.CallFunc:create(function ()
                    critter:removeFromParent()
                end))
                
                critter:runAction(cc.Sequence:create(actions))
            end
        end,  
    },
    {
        time = 4,
        callback = function (sender,task)
            local node = sender:getUserData().enemyLayer
            --从右往左
            for i = 1,6 do
                local critter = THSTG.UI.newNode({
                    x = display.width + i*60,
                    y = display.cy,
                    height = 40,
                    width = 40,
                    anchorPoint = THSTG.UI.POINT_RIGHT_CENTER,
                })

                node:addChild(critter)
                debugUI(critter)

                local actions = {}
                table.insert(actions, cc.MoveBy:create(8.0,cc.p(-(2*display.width),0)))
                table.insert(actions,cc.CallFunc:create(function ()
                    critter:removeFromParent()
                end))
                
                critter:runAction(cc.Sequence:create(actions))
            end
        end,  
    },
    {
        time = 1.5,
        callback = function (sender)
            print(15,sender:time())
        end,  
    },
    {
        time = 1,
        callback = function (sender)
            -- 右边生成2个小怪,向上移动
            local node = sender:getUserData().enemyLayer
             for i = 1,2 do
                local critter = THSTG.UI.newNode({
                    x = display.width - 40,
                    y = 0 - (i-1) * 60,
                    height = 40,
                    width = 40,
                    anchorPoint = THSTG.UI.POINT_RIGHT_TOP,
                })
                critter:setPositionY(StageDef.ScenarioUtil.calculateBoundY(critter,i,10,true))
                node:addChild(critter)
                debugUI(critter)

                local actions = {}
                table.insert(actions,cc.MoveBy:create(8.0,cc.p(0,(2*display.height))))
                table.insert(actions,cc.CallFunc:create(function ()
                    critter:removeFromParent()
                end))
                
                critter:runAction(cc.Sequence:create(actions))
            end
        end,
    },
}