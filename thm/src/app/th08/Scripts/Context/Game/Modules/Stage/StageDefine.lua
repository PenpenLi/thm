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
BulletEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BulletEntity")
PlayerEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.PlayerEntity")

BulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BulletPrefab")
PlayerPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.PlayerPrefab")

EnemyBullet = require("Scripts.Context.Game.Modules.Stage.Entity.EnemyBullet")
PlayerBullet = require("Scripts.Context.Game.Modules.Stage.Entity.PlayerBullet")
Player = require("Scripts.Context.Game.Modules.Stage.Entity.Player")


-- LilyWhite = require("Scripts.Context.Game.Modules.Stage.Entity.LilyWhite")
-- Yukari = require("Scripts.Context.Game.Modules.Stage.Entity.Yukari")
-- Sakuya = require("Scripts.Context.Game.Modules.Stage.Entity.Sakuya")
----


--
BulletController = require("Scripts.Context.Game.Modules.Stage.System.BulletController")
PlayerController = require("Scripts.Context.Game.Modules.Stage.System.PlayerController")
BatmanController = require("Scripts.Context.Game.Modules.Stage.System.BatmanController")
DestoryByBorder = require("Scripts.Context.Game.Modules.Stage.System.DestoryByBorder")
---
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  