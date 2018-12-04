module("EventType", package.seeall)
--格式
--模块名_事件名_状态

PUBLIC_MODULE_OPENED = UIDUtil.getEventUID()--有模块打开了
PUBLIC_MODULE_CLOSED = UIDUtil.getEventUID()--有模块关闭了
PUBLIC_MODULE_OPENING = UIDUtil.getEventUID()--有模块打开即将打开

PUBLIC_OPEN_MODULE = UIDUtil.getEventUID()--打开模块
PUBLIC_CLOSE_MODULE = UIDUtil.getEventUID()--关闭模块

GAME_LOGIC_UPDATE = UIDUtil.getEventUID()