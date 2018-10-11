THSTG = THSTG or {}
---事件
require "thstg.Framework.Component.Event.CCEventComponent"
THSTG.DispatcherManager = require "thstg.Framework.Component.Event.DispatcherManager"
THSTG.Dispatcher = require "thstg.Framework.Component.Event.Dispatcher"
THSTG.CCDispatcher = THSTG.EVENT.getEventDispatcher()

--定时器
THSTG.Scheduler = require "thstg.Framework.Component.Schedule.Scheduler"

--Scene组件
require "thstg.Framework.Component.Scene.Init"

--UI组件
require "thstg.Framework.Component.UI.Init"