-- local layer = THSTG.ModuleManager.get(ModuleType.STAGE)
local layer = THSTG.SceneManager.get(SceneType.STAGE).entityLayer
return {
    {
        time = 1,
        callback  = function (scheduler,task,params)
            --左边生成三个小怪,并向下移动
            local posX = 40
            local posY = 0
            for i = 1,3 do
                posY = display.height - (i-1) * 60
                local batman = StageDefine.Batman.new()
                local posComp = batman:getComponent("PositionComponent")
                posComp.x = posX
                posComp.y = posY
                layer:addChild(batman)

                local actions = {}
                --TODO:由于移动组件的关系,这个不能用了
                table.insert(actions, cc.MoveBy:create(8.0,cc.p(0,-(2*display.height))))  
                table.insert(actions,cc.CallFunc:create(function ()
                    batman:destroy()
                    scheduler:resume()
                end))
                scheduler:pause()
                batman:runAction(cc.Sequence:create(actions))
            end

            scheduler:pause()
        end
    },
    {
        time = 2,
        callback  = function (scheduler,task,params)
           

            scheduler:pause()
        end,
    },
    {
        time = 3,
        callback  = function (scheduler,task,params)


            scheduler:pause()
        end,
    },
    {
        time = 4,
        callback = function (scheduler,task,params)

            
            scheduler:pause()
        end,  
    },
    {
        time = 5,
        callback = function (scheduler,task,params)


            scheduler:pause()
        end,  
    },
    {
        time = 6,
        callback = function (scheduler,task,params)


            scheduler:pause()
        end,  
    },
    {
        time = 7,
        callback = function (scheduler,task,params)

            
            scheduler:pause()
        end,
    },
}