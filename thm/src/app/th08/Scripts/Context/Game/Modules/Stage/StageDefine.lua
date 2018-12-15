module("StageDefine", package.seeall)

----
Speed = require("Scripts.Context.Game.Modules.Stage.Component.Data.Speed")

--
AnimationComponent = require("Scripts.Context.Game.Modules.Stage.Component.AnimationComponent")
PositionComponent = require("Scripts.Context.Game.Modules.Stage.Component.PositionComponent")
FlagComponent = require("Scripts.Context.Game.Modules.Stage.Component.FlagComponent")
LifeComponent = require("Scripts.Context.Game.Modules.Stage.Component.LifeComponent")
InputComponent = require("Scripts.Context.Game.Modules.Stage.Component.InputComponent")
RigidbodyComponent = require("Scripts.Context.Game.Modules.Stage.Component.RigidbodyComponent")
----

----
BaseEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BaseEntity")
MovableEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.MovableEntity")
LivedEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.LivedEntity")
EnemyEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.EnemyEntity")
PlayerEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.PlayerEntity")

Bullet = require("Scripts.Context.Game.Modules.Stage.Entity.Bullet")
Reimu = require("Scripts.Context.Game.Modules.Stage.Entity.Reimu")
Yukari = require("Scripts.Context.Game.Modules.Stage.Entity.Yukari")  
LilyWhite = require("Scripts.Context.Game.Modules.Stage.Entity.LilyWhite")  
----
CollisionSystem = require("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")  





---
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  