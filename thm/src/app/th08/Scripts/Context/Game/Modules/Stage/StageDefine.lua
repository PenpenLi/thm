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

BulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BulletPrefab")
PlayerPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.PlayerPrefab")


Yukari = require("Scripts.Context.Game.Modules.Stage.Entity.Yukari")
----
CollisionSystem = require("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")  
PlayerControlSystem = require("Scripts.Context.Game.Modules.Stage.System.PlayerControlSystem")  
PlayerAnimationSystem = require("Scripts.Context.Game.Modules.Stage.System.PlayerAnimationSystem")  

---
RoleType = require("Scripts.Context.Game.Modules.Stage.Config.Type.RoleType")  
ActionType = require("Scripts.Context.Game.Modules.Stage.Config.Type.ActionType")  
---
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  