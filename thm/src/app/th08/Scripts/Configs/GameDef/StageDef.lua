module("Stage", package.seeall)

STAGE_VIEW_SIZE = cc.size(640,480)     --舞台的视图尺寸,不等于窗口大小

MAX_BARRAGE_NUM = 32768         --最大弹幕数

PLAYER_KEY_MOVE_STEP = 3        --玩家一步的像素步伐
PLAYER_TOUCH_MOVE_STEP = 3      --玩家接触移动的步伐
PLAYER_DEATH_SAVE_TIME = 0.13   --决死的时间
PLAYER_INVINCIBLE_TIME = 4      --无敌的时间


-------
EModeType = {
    Story = 1,
    BossRush = 2,
}

EEntityType = {
    Player = 1,
    Wingman = 2,
    Boss = 3,
    Batman = 4,
    PlayerBullet = 5,
    EnemyBullet = 6,
    WingmanBullet = 7,
    Prop = 8,
}

EEntityFlag = {
    Player = 1,
    Enemy = 2, 
}

EPlayerType = {
    Reimu = 1,          --Reimu
    Yukari = 2,         --Yukari
    Marisa = 3,         --Marisa
    Sakuya = 4,
}

EBossType = {
    Wriggle = 1,     --莉格露
}

--道具种类
EPropCategory = {
    Card = 1,           --卡片
}

EPropCardType = {
    Power = 1,          --火力
    Bomb = 2,           --Bomb
    Flag = 3,           --F???
    OneUp = 4,          --1Up
    Da = 5,             --???
    Water = 6,          --???
    Point = 7,          --点数

}

EBulletCategory = {                     --子弹种类
    Dot = 1,                            --点
    Laser = 2,                          --激光
}

EBulletColor = {                    --子弹颜色
    _1 = 1,
    _2 = 2,
    _3 = 3,
    _4 = 4,
    _5 = 5,
    _6 = 6,
    _7 = 7,
    _8 = 8,
    _9 = 9,
    _10 = 10,
    _11 = 11,
    _12 = 12,
    _13 = 13,
    _14 = 14,
    _15 = 15,
    _16 = 16,
}
