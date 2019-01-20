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
--主控制器
BaseController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BaseController")
BatmanController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BatmanController")
BossController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BossController")
---舞台控制器
StageGameController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Stage.StageGameController")
---子弹控制器
BulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.BulletController")
PlayerBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.PlayerBulletController")
EnemyBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.EnemyBulletController")
---自机控制
PlayerController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.PlayerController")
---道具控制
PropController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Prop.PropController")


--GUI系统
HealthBarController = require("Scripts.Context.Game.Modules.Stage.Script.Module.GUI.HealthBarController")

--符卡系统
BaseSpellController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Spell.BaseSpellController")
PlayerSpellController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Spell.PlayerSpellController")
EnemySpellController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Spell.EnemySpellController")
BossSpellController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Spell.BossSpellController")

--生命控制
HealthController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.HealthController")
BatmanHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.BatmanHealth")
BossHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.BossHealth")
PlayerHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.PlayerHealth")
BulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.Bullet.BulletHealth")
PlayerBulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.Bullet.PlayerBulletHealth")
EnemyBulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.Bullet.EnemyBulletHealth")
--碰撞控制
CollisionController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.CollisionController")
PlayerCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.PlayerCollision")
---子弹的碰撞控制
BulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.Bullet.BulletCollision")
PlayerBulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.Bullet.PlayerBulletCollision")



--输入控制
InputController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Input.InputController")
PlayerInput = require("Scripts.Context.Game.Modules.Stage.Script.Module.Input.PlayerInput")

--动画控制
AnimationController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.AnimationController")
BossAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BossAnimation")
BatmanAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BatmanAnimation")
BulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BulletAnimation")
PlayerAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.PlayerAnimation")

--剧本控制
ScenarioController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Scenario.ScenarioController")

--公共脚本
DestroyByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByBorder")
ConstraintByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.ConstraintByBorder")

---[[工具]]-----
AnimationUtil = require("Scripts.Context.Game.Modules.Stage.Util.AnimationUtil")  
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  



------
--[[轮询的系统注册]]---
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.PhysicsSystem")
