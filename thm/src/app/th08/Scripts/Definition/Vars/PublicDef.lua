module("Public", package.seeall)

ANIMATION_INTERVAL = 1/12       --动画默认的帧率

-------
--游戏按键映射
EGameKeyType = {
    MoveUp = 1,
    MoveDown = 2,
    MoveLeft = 3,
    MoveRight = 4,

    Attack = 5,
    Wipe = 6,
    Bomb = 7,
    Slow = 8,
}

--玩家行为
EPlayerActionStatus = {
    Normal = 0,
    MoveLeft = 1,
    MoveRight = 2,
    MoveUp = 4,
    MoveDown = 8,
    Shot = 16,
    Skill = 32,
}

--忙碌类型
EBusyType = {
    Unknow = 1,
    Loading = 2,
    Waiting = 3,
}

