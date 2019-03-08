--预先生成310个bullet
local EEntityType = Const.Stage.EEntityType
local EEnemyBulletType = Const.Stage.EEnemyBulletType
local EBatmanType = Const.Stage.EBatmanType
local ScenarioUtil = StageDefine.ScenarioUtil
EntityManager.expandEntity(EEntityType.EnemyBullet,EEnemyBulletType.BigJade,300)
return {
    {
        time = 1,
        callback  = function (sender,task)
            EntityManager.createEnemyBullet(EEnemyBulletType.BigJade,cc.p(display.cx,display.cy),cc.p(0,0))

            EntityManager.createEnemyBullets(EEnemyBulletType.BigJade,20,function(i,obj)
                local initPos = ScenarioUtil.calCirclePos(cc.p(display.cx,display.cy),120,20,i)
                obj:runAction(cc.MoveTo:create(1,cc.p(display.cx,display.cy)))

                return initPos,cc.p(0,0)
            end)

            EntityManager.createBatmans(EBatmanType.Fairy01,1,function(i,e)
                return cc.p(display.cx,display.cy),cc.p(0,0)
            end)
        end
    },
   
}