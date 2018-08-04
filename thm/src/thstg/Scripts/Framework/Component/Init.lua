THSTG = THSTG or {}

require "thstg.Scripts.Framework.Component.Event.CCEventComponent"
THSTG.DispatcherManager = require "thstg.Scripts.Framework.Component.Event.DispatcherManager"
THSTG.Dispatcher = require "thstg.Scripts.Framework.Component.Event.Dispatcher"
THSTG.CCDispatcher = THSTG.EVENT.getEventDispatcher()

THSTG.Scheduler = require "thstg.Scripts.Framework.Component.Schedule.Scheduler"

