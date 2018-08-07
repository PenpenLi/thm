THSTG = THSTG or {}

require "thstg.Framework.Component.Event.CCEventComponent"
THSTG.DispatcherManager = require "thstg.Framework.Component.Event.DispatcherManager"
THSTG.Dispatcher = require "thstg.Framework.Component.Event.Dispatcher"
THSTG.CCDispatcher = THSTG.EVENT.getEventDispatcher()

THSTG.Scheduler = require "thstg.Framework.Component.Schedule.Scheduler"

require "thstg.Framework.Component.Scene.CCSceneComponent"
