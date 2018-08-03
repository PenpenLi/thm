THSTG = THSTG or {}

require "thstg.Scripts.Frame.Component.Event.CCEventComponent"
THSTG.DispatcherManager = require "thstg.Scripts.Frame.Component.Event.DispatcherManager"
THSTG.Dispatcher = require "thstg.Scripts.Frame.Component.Event.Dispatcher"
THSTG.CCDispatcher = THSTG.EVENT.getEventDispatcher()

THSTG.Scheduler = require "thstg.Scripts.Frame.Component.Schedule.Scheduler"

