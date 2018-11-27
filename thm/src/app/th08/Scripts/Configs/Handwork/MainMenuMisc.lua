return {
    menu_delay_time = 6,
    menus = 
    {
        {
            title = Language.getString(100101),
            desc = Language.getString(100111), 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(20,0) ,
            file = "Scripts.Game.Modules.GUI.GameUi.StartMenu.StartLayer",
            onClick = function ()
                
            end,
        },
        {
            title = Language.getString(100102),
            desc = Language.getString(100112), 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(-20,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = Language.getString(100103),
            desc = Language.getString(100113), 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(15,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = Language.getString(100104),
            desc = Language.getString(100114), 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(-15,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = Language.getString(100105),
            desc = Language.getString(100115), 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(20,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = Language.getString(100106),
            desc = Language.getString(100116), 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(-15,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = Language.getString(100107),
            desc = Language.getString(100117), 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(20,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = Language.getString(100108),
            desc = Language.getString(100118), 
            offsetPos = cc.p(0,0),
            moveBy = cc.p(-15,0) ,
            file = "",
            onClick = function ()
            
            end,
        },
        {
            title = Language.getString(100109),
            desc = Language.getString(100119), 
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