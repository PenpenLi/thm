--预先生成310个bullet
local EEnemyBulletType = Const.Stage.EEnemyBulletType
local EntityManager = StageDefine.EntityManager
local ScenarioUtil = StageDefine.ScenarioUtil
return {
    {
        time = 1,
        callback  = function (sender,task)
            local obj = EntityManager.createEnemyBullet(EEnemyBulletType.BigJade,cc.p(display.cx,display.cy),cc.p(0,0))
            obj:setActive(true)


            EntityManager.createEnemyBullets(EEnemyBulletType.BigJade,20,function(i,obj)

                local initPos = ScenarioUtil.calCirclePos(cc.p(display.cx,display.cy),120,20,i)
                obj:runAction(cc.MoveTo:create(1,cc.p(display.cx,display.cy)))
                obj:setActive(true)

                return initPos,cc.p(0,0)
            end)

        end
    },
   
}