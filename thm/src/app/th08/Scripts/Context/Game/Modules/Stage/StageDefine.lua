module("StageDefine", package.seeall)

---[[组件]]----
SpriteComponent = require("Scripts.Context.Game.Modules.Stage.Component.SpriteComponent")
AnimationComponent = require("Scripts.Context.Game.Modules.Stage.Component.AnimationComponent")
TransformComponent = require("Scripts.Context.Game.Modules.Stage.Component.TransformComponent")
ActionComponent = require("Scripts.Context.Game.Modules.Stage.Component.ActionComponent")
InputComponent = require("Scripts.Context.Game.Modules.Stage.Component.InputComponent")
RigidbodyComponent = require("Scripts.Context.Game.Modules.Stage.Component.RigidbodyComponent")
AudioComponent = require("Scripts.Context.Game.Modules.Stage.Component.AudioComponent")
BoxColliderComponent = require("Scripts.Context.Game.Modules.Stage.Component.Collider.BoxColliderComponent")
CircleColliderComponent = require("Scripts.Context.Game.Modules.Stage.Component.Collider.CircleColliderComponent")
----

---[[实体]]----
EmptyEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.EmptyEntity")
BaseEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BaseEntity")
MovableEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.MovableEntity")
LivedEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.LivedEntity")
EnemyEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.EnemyEntity")
BossEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BossEntity")
BulletEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BulletEntity")
PlayerEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.PlayerEntity")

BossPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BossPrefab")
BatmanPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BatmanPrefab")
BulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BulletPrefab")
PlayerPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.PlayerPrefab")
HealthBarPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.HealthBarPrefab")

EnemyBullet = require("Scripts.Context.Game.Modules.Stage.Entity.EnemyBullet")
PlayerBullet = require("Scripts.Context.Game.Modules.Stage.Entity.PlayerBullet")
Player = require("Scripts.Context.Game.Modules.Stage.Entity.Player")
Boss = require("Scripts.Context.Game.Modules.Stage.Entity.Boss")
Batman = require("Scripts.Context.Game.Modules.Stage.Entity.Batman")
StageGame = require("Scripts.Context.Game.Modules.Stage.Entity.StageGame")

---[[脚本]]----
BaseController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BaseController")
BulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.BulletController")
PlayerBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.PlayerBulletController")
EnemyBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.EnemyBulletController")
PlayerController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.PlayerController")
BatmanController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BatmanController")
BossController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BossController")
StageGameController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.StageGameController")

HealthBarController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.GUI.HealthBarController")

--生命控制
HealthController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.HealthController")
BatmanHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.BatmanHealth")
BossHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.BossHealth")
PlayerHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.PlayerHealth")
BulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.BulletHealth")

--碰撞控制
CollisionController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.CollisionController")
PlayerCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.PlayerCollision")
BulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.BulletCollision")

--输入控制
InputController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Input.InputController")
PlayerInput = require("Scripts.Context.Game.Modules.Stage.Script.Module.Input.PlayerInput")

--动画控制
AnimationController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.AnimationController")
BossAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BossAnimation")
BatmanAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BatmanAnimation")
BulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BulletAnimation")
PlayerAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.PlayerAnimation")

--公共脚本
DestroyByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByBorder")
ConstraintByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.ConstraintByBorder")

---[[工具]]-----
AnimationUtil = require("Scripts.Context.Game.Modules.Stage.Util.AnimationUtil")  
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  



------
--[[轮询的系统注册]]---
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")
-- THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.InputSystem")
-- THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.PhysicsSystem")
