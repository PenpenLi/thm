-- 实体与层级映射表
local EEntityType = GameDef.Stage.EEntityType

return {
    [EEntityType.Player] = function () 
        return THSTG.SceneManager.getCurScene().playerLayer
    end,
    [EEntityType.Wingman] = function () 
        return THSTG.SceneManager.getCurScene().barrageLayer
    end,
    [EEntityType.Boss] = function () 
        return THSTG.SceneManager.getCurScene().barrageLayer
    end,
    [EEntityType.Batman] = function () 
        return THSTG.SceneManager.getCurScene().barrageLayer
    end,
    [EEntityType.PlayerBullet] = function () 
        return THSTG.SceneManager.getCurScene().barrageLayer
    end,
    [EEntityType.EnemyBullet] = function () 
        return THSTG.SceneManager.getCurScene().barrageLayer
    end,
    [EEntityType.WingmanBullet] = function () 
        return THSTG.SceneManager.getCurScene().barrageLayer
    end,
    [EEntityType.Prop] = function () 
        return THSTG.SceneManager.getCurScene().barrageLayer
    end,
}