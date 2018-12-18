module("StageDefine", package.seeall)


---
RoleType = require("Scripts.Context.Game.Modules.Stage.Config.Type.RoleType")  
ActionType = require("Scripts.Context.Game.Modules.Stage.Config.Type.ActionType")  

----
Speed = require("Scripts.Context.Game.Modules.Stage.Component.Data.Speed")

--
AnimationComponent = require("Scripts.Context.Game.Modules.Stage.Component.AnimationComponent")
PositionComponent = require("Scripts.Context.Game.Modules.Stage.Component.PositionComponent")
InputComponent = require("Scripts.Context.Game.Modules.Stage.Component.InputComponent")
RigidbodyComponent = require("Scripts.Context.Game.Modules.Stage.Component.RigidbodyComponent")
AudioComponent = require("Scripts.Context.Game.Modules.Stage.Component.AudioComponent")
----

----
BaseEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BaseEntity")
MovableEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.MovableEntity")
LivedEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.LivedEntity")
EnemyEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.EnemyEntity")
PlayerEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.PlayerEntity")

BulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BulletPrefab")
PlayerPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.PlayerPrefab")


Bullet = require("Scripts.Context.Game.Modules.Stage.Entity.Bullet")
LilyWhite = require("Scripts.Context.Game.Modules.Stage.Entity.LilyWhite")
Yukari = require("Scripts.Context.Game.Modules.Stage.Entity.Yukari")
Sakuya = require("Scripts.Context.Game.Modules.Stage.Entity.Sakuya")
----
-- CollisionSystem = require("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")  
-- PlayerControlSystem = require("Scripts.Context.Game.Modules.Stage.System.PlayerControlSystem")  
-- PlayerAnimationSystem = require("Scripts.Context.Game.Modules.Stage.System.PlayerAnimationSystem")  

--

PlayerMove = require("Scripts.Context.Game.Modules.Stage.Script.PlayerMove")  
---
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  