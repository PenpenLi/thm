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

EEntityLayerType = {
    Player = 1,
    Barrage = 2,
    
}

EEntityType = {
    Player = 1,
    Wingman = 2,
    Boss = 3,
    Batman = 4,
    PlayerBullet = 5,
    EnemyBullet = 6,
    WingmanBullet = 7,
}

ERoleType = {
    Reimu = 1,          --Reimu
    Yukari = 2,         --Yukari
    Marisa = 3,         --Marisa
    Sakuya = 4,
}

-------
EBossType = {
    WriggleNightbug = 1,     --莉格露
}

EWingmanType = {
    OnmyouGyoku = 1,
}

EBatmanType = {
    Fairy01 = 1,
    Cyclone01 = 2,
}

EPropType = {
    Power = 1,                      --P弹
    Bomb = 2,                       --B弹
}

EBulletCategory = {                 --子弹类型
    Dot,
    Laser,
}

EBulletColor = {                    --子弹颜色

}

EPlaerBulletType = {
    JiAmulet = 1,               --咒符·集
    SanAmulet = 2,              --咒符·散
}

EEnemyBulletType = {
    SmallJade = 301,      --小玉
    BigJade = 303,        --大玉,
}

ESpellCardCategory = {
    Non,--非符
    Time,--时符
    Final,--终符
}