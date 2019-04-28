return {
    menu_delay_time = 6,
    menus = 
    {
        {
            title = "Start",
            desc = "开始游戏", 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(20,0) ,
            file = "Scripts.Context.Game.Modules.Selection.Layer.SelectionLayer",
            onClick = function ()
                
            end,
        },
        {
            title = "Extra Start",
            desc = "开始EX关卡", 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(-20,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = "Spell Practice",
            desc = "和敌人进行符卡战斗", 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(15,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = "Practice Start",
            desc = "选择关卡开始练习", 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(-15,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = "Replay",
            desc = "可以欣赏录像",
            offsetPos = cc.p(0,0),
            moveBy = cc.p(20,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = "Result",
            desc = "查看过去游戏中分数和符卡的取得情况",
            offsetPos = cc.p(0,0),
            moveBy = cc.p(-15,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = "Music Room",
            desc = "可以欣赏音乐",
            offsetPos = cc.p(0,0),
            moveBy = cc.p(20,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = "Option",
            desc = "可以进行各种设定", 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(-15,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = "Quit",
            desc = "退出游戏", 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(20,0) ,
            file = "",
            onClick = function ()
                --退出游戏
                FlowManager.quitGame()
            end,
        },
    },  
    
}