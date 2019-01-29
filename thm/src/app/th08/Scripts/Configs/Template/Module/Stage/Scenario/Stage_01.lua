
return {
    {
        time = 1,
        callback  = function (scheduler,task,params)
            --左边生成三个小怪,并向下移动
            local posX = 40
            local posY = 0
            for i = 1,3 do
                posY = display.height - (i-1) * 60
                local batman = StageDefine.BatmanPrefab.new()
                local posComp = batman:getComponent("TransformComponent")
                posComp:setPositionX(posX)
                posComp:setPositionY(posY)
                

                local actions = {}
                table.insert(actions, cc.MoveBy:create(8.0,cc.p(0,-(3*display.height))))  
                table.insert(actions,cc.CallFunc:create(function ()
                    batman:destroy()
                    scheduler:resume()
                end))
                local actionComp = batman:getComponent("ActionComponent")
                actionComp:runAction(cc.Sequence:create(actions))
            end

        end
    },
    {
        time = 1,
        callback  = function (scheduler,task,params)
           --左边生成三个小怪,并向下移动
           local posX = 300
           local posY = 0
           for i = 1,3 do
               posY = display.height - (i-1) * 60
               local batman = StageDefine.BatmanPrefab.new()
               local posComp = batman:getComponent("TransformComponent")
               posComp:setPositionX(posX)
               posComp:setPositionY(posY)
               

               local actions = {}
               table.insert(actions, cc.MoveBy:create(8.0,cc.p(0,-(3*display.height))))  
               table.insert(actions,cc.CallFunc:create(function ()
                   batman:destroy()
                   scheduler:resume()
               end))
               local actionComp = batman:getComponent("ActionComponent")
               actionComp:runAction(cc.Sequence:create(actions))
           end


            
        end,
    },
    {
        time = 1,
        callback  = function (scheduler,task,params)
           --左边生成三个小怪,并向下移动
           local posX = 600
           local posY = 0
           for i = 1,3 do
               posY = display.height - (i-1) * 60
               local batman = StageDefine.BatmanPrefab.new()
               local posComp = batman:getComponent("TransformComponent")
               posComp:setPositionX(posX)
               posComp:setPositionY(posY)
               

               local actions = {}
               table.insert(actions, cc.MoveBy:create(8.0,cc.p(0,-(3*display.height))))  
               table.insert(actions,cc.CallFunc:create(function ()
                   batman:destroy()
                   scheduler:resume()
               end))
               local actionComp = batman:getComponent("ActionComponent")
               actionComp:runAction(cc.Sequence:create(actions))
           end


            
        end,
    },
    {
        time = 3,
        callback  = function (scheduler,task,params)
            --左边生成三个小怪,并向下移动
           local posX = 0
           local posY = display.height - 100
           for i = 1,3 do
               posX = - (i-1) * 60
               local batman = StageDefine.BatmanPrefab.new()
               local posComp = batman:getComponent("TransformComponent")
               posComp:setPositionX(posX)
               posComp:setPositionY(posY)
               

               local actions = {}
               table.insert(actions, cc.MoveBy:create(8.0,cc.p(3*display.width,0)))  
               table.insert(actions,cc.CallFunc:create(function ()
                   batman:destroy()
                   scheduler:resume()
               end))
               local actionComp = batman:getComponent("ActionComponent")
               actionComp:runAction(cc.Sequence:create(actions))
           end

           for i = 1,3 do
                posX = display.width + (i-1) * 60
                local batman = StageDefine.BatmanPrefab.new()
                local posComp = batman:getComponent("TransformComponent")
                posComp:setPositionX(posX)
                posComp:setPositionY(posY)
                

                local actions = {}
                table.insert(actions, cc.MoveBy:create(8.0,cc.p(-3*display.width,0)))  
                table.insert(actions,cc.CallFunc:create(function ()
                    batman:destroy()
                    scheduler:resume()
                end))
                local actionComp = batman:getComponent("ActionComponent")
                actionComp:runAction(cc.Sequence:create(actions))
            end

        end,
    },
    {
        time = 1,
        callback = function (scheduler,task,params)
            ObjectCache.pick(StageDefine.BatmanPrefab,4,function(batman,i)
                

                local trans = batman:getComponent("TransformComponent")
                trans:setPositionX(0)
                trans:setPositionY(display.height - 32 * i)
                

                local actionComp = batman:getComponent("ActionComponent")
                actionComp:runAction(cc.Sequence:create({
                    cc.EaseQuadraticActionOut:create(cc.MoveTo:create(6.0,cc.p(200,display.height*0.40))),
                    cc.EaseSineIn:create(cc.MoveTo:create(6.0,cc.p(0- i *32,display.height*1.5+ i *32))),
                    cc.CallFunc:create(function() ObjectCache.release(batman) end)


                }))
            end)

            ObjectCache.pick(StageDefine.BatmanPrefab,4,function(batman,i)

                local trans = batman:getComponent("TransformComponent")
                trans:setPositionX(display.width + 1)
                trans:setPositionY(display.height - 32 * i)
                

                local actionComp = batman:getComponent("ActionComponent")
                actionComp:runAction(cc.Sequence:create({
                    cc.EaseQuadraticActionOut:create(cc.MoveTo:create(6.0,cc.p(display.width-200,display.height*0.40))),
                    cc.EaseSineIn:create(cc.MoveTo:create(6.0,cc.p(display.width+ i *32,display.height*1.5 + i *32))),
                    cc.CallFunc:create(function() ObjectCache.release(batman) end)


                }))
            end)
        end,  
    },
    {
        time = 5,
        callback = function (scheduler,task,params)


            
        end,  
    },
    {
        time = 6,
        callback = function (scheduler,task,params)


            
        end,  
    },
    {
        time = 7,
        callback = function (scheduler,task,params)

            
            
        end,
    },
}