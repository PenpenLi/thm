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

---[[脚本]]----
BulletController = require("Scripts.Context.Game.Modules.Stage.Script.BulletController")
PlayerController = require("Scripts.Context.Game.Modules.Stage.Script.PlayerController")
BatmanController = require("Scripts.Context.Game.Modules.Stage.Script.BatmanController")

--公共脚本
DestroyByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByBorder")
ConstraintByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.ConstraintByBorder")

--生命控制
HealthController = require("Scripts.Context.Game.Modules.Stage.Script.Health.HealthController")
BatmanHealth = require("Scripts.Context.Game.Modules.Stage.Script.Health.BatmanHealth")
PlayerHealth = require("Scripts.Context.Game.Modules.Stage.Script.Health.PlayerHealth")
BulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Health.BulletHealth")

--碰撞控制
CollisionController = require("Scripts.Context.Game.Modules.Stage.Script.Collision.CollisionController")
PlayerCollision = require("Scripts.Context.Game.Modules.Stage.Script.Collision.PlayerCollision")
BatmanCollision = require("Scripts.Context.Game.Modules.Stage.Script.Collision.BatmanCollision")
BulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Collision.BulletCollision")

InputController = require("Scripts.Context.Game.Modules.Stage.Script.Input.InputController")
PlayerInput = require("Scripts.Context.Game.Modules.Stage.Script.Input.PlayerInput")

--动画控制
AnimationController = require("Scripts.Context.Game.Modules.Stage.Script.Animation.AnimationController")
BatmanAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Animation.BatmanAnimation")
BulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Animation.BulletAnimation")
PlayerAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Animation.PlayerAnimation")

--移动控制
MoveController = require("Scripts.Context.Game.Modules.Stage.Script.Move.MoveController")
BulletMove = require("Scripts.Context.Game.Modules.Stage.Script.Move.BulletMove")

---[[工具]]-----
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  

------
--[[轮询的系统注册]]---
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")
-- THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.InputSystem")
-- THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.PhysicsSystem")