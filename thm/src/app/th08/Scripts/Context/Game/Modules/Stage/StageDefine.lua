module("StageDefine", package.seeall)


---
-- RoleType = require("Scripts.Context.Game.Modules.Stage.Config.Type.RoleType")  
ActionType = require("Scripts.Context.Game.Modules.Stage.Config.Type.ActionType")  

--
AnimationComponent = require("Scripts.Context.Game.Modules.Stage.Component.AnimationComponent")
TransformComponent = require("Scripts.Context.Game.Modules.Stage.Component.TransformComponent")
ActionComponent = require("Scripts.Context.Game.Modules.Stage.Component.ActionComponent")
InputComponent = require("Scripts.Context.Game.Modules.Stage.Component.InputComponent")
RigidbodyComponent = require("Scripts.Context.Game.Modules.Stage.Component.RigidbodyComponent")
AudioComponent = require("Scripts.Context.Game.Modules.Stage.Component.AudioComponent")
BoxColliderComponent = require("Scripts.Context.Game.Modules.Stage.Component.Collider.BoxColliderComponent")
CircleColliderComponent = require("Scripts.Context.Game.Modules.Stage.Component.Collider.CircleColliderComponent")
----

----
BaseEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BaseEntity")
MovableEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.MovableEntity")
LivedEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.LivedEntity")
EnemyEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.EnemyEntity")
BulletEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BulletEntity")
PlayerEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.PlayerEntity")

BatmanPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BatmanPrefab")
BulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BulletPrefab")
PlayerPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.PlayerPrefab")

EnemyBullet = require("Scripts.Context.Game.Modules.Stage.Entity.EnemyBullet")
PlayerBullet = require("Scripts.Context.Game.Modules.Stage.Entity.PlayerBullet")
Player = require("Scripts.Context.Game.Modules.Stage.Entity.Player")
Batman = require("Scripts.Context.Game.Modules.Stage.Entity.Batman")

-- LilyWhite = require("Scripts.Context.Game.Modules.Stage.Entity.LilyWhite")
-- Yukari = require("Scripts.Context.Game.Modules.Stage.Entity.Yukari")
-- Sakuya = require("Scripts.Context.Game.Modules.Stage.Entity.Sakuya")

--
BulletController = require("Scripts.Context.Game.Modules.Stage.Script.BulletController")
PlayerController = require("Scripts.Context.Game.Modules.Stage.Script.PlayerController")
BatmanController = require("Scripts.Context.Game.Modules.Stage.Script.BatmanController")
DestroyByBorder = require("Scripts.Context.Game.Modules.Stage.Script.DestroyByBorder")
DestroyByBullet = require("Scripts.Context.Game.Modules.Stage.Script.DestroyByBullet")
HealthController = require("Scripts.Context.Game.Modules.Stage.Script.HealthController")
---
ConfigReader = require("Scripts.Context.Game.Modules.Stage.Config.ConfigReader")  
---
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  


------
--轮询的系统注册
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")