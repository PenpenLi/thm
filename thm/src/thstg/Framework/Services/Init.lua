
Scheduler = require "thstg.Framework.Services.Scheduler"
Dispatcher = require "thstg.Framework.Services.Dispatcher"
AudioEngine = require "thstg.Framework.Services.AudioEngine"
AnimationServer = require "thstg.Framework.Services.AnimationServer"
EffectServer = require "thstg.Framework.Services.EffectServer"

----
--调用时用冒号
CCDispatcher = EVENT.getEventDispatcher()
MVCDispatcher = EVENT.DispatcherManager.getNew()
ECSDispatcher = EVENT.DispatcherManager.getNew()