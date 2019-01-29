module("Definition.Public", package.seeall)

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

ETouchType = {
    OnceClick = 301,
    DoubleClick = 302,
    LongClick = 303,
    Shake = 304,
    MultiTouch = 305,
}

EBusyType = {
    Unknow = 1,
    Loading = 2,
    Waiting = 3,
}

EPlayerActionStatus = {
    Normal = 0,
    MoveLeft = 1,
    MoveRight = 2,
    MoveUp = 4,
    MoveDown = 8,
    Shot = 16,
    Skill = 32,
}