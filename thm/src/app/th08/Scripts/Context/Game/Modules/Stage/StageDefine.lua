module("StageDefine", package.seeall)

------
---[[数据]]----
BaseEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.BaseEntityData")
PlayerEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.PlayerEntityData")
WingmanEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.WingmanEntityData")
BossEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.BossEntityData")
BatmanEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.BatmanEntityData")
PlayerBulletEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.PlayerBulletEntityData")
EnemyBulletEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.EnemyBulletEntityData")
WingmanBulletEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.WingmanBulletEntityData")
PropEntityData = require("Scripts.Context.Game.Modules.Stage.Data.Entity.PropEntityData")
---[[组件]]----
TransformComponent = THSTG.ECS.TransformComponent
SpriteComponent = THSTG.ECS.SpriteComponent
AnimationComponent = THSTG.ECS.AnimationComponent
TransformComponent = THSTG.ECS.TransformComponent
ActionComponent = THSTG.ECS.ActionComponent
InputComponent = THSTG.ECS.InputComponent
RigidbodyComponent = THSTG.ECS.RigidbodyComponent
AudioComponent = THSTG.ECS.AudioComponent
SchedulerComponent = require("Scripts.Context.Game.Modules.Stage.Component.SchedulerComponent")
BoxColliderComponent = THSTG.ECS.BoxColliderComponent
CircleColliderComponent = THSTG.ECS.CircleColliderComponent

------
---[[实体]]----
BaseEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BaseEntity")
MovableEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.MovableEntity")
LivedEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.LivedEntity")
EnemyEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.EnemyEntity")
BossEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BossEntity")
BulletEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.BulletEntity")
PlayerEntity = require("Scripts.Context.Game.Modules.Stage.Entity.Basic.PlayerEntity")

--预制体基类
BatmanPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.BatmanPrefab")
PlayerPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.PlayerPrefab")
WingmanPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.WingmanPrefab")
BulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.BulletPrefab")
EnemyBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.EnemyBulletPrefab")
PlayerBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.PlayerBulletPrefab")
WingmanBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.WingmanBulletPrefab")
BossPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.BossPrefab")
PropPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.PropPrefab")

--预制体
EmitterPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.EmitterPrefab")--发射口预制体
ReimuBullet = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Bullet.Player.ReimuBullet")---自机子弹
OnmyouGyokuBullet = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Bullet.Player.OnmyouGyokuBullet")--僚机子弹
Wriggle = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Boss.Wriggle")
OnmyouGyoku = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Wingman.OnmyouGyoku")
Reimu = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Player.Reimu")
Marisa = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Player.Marisa")

StageGame = require("Scripts.Context.Game.Modules.Stage.Entity.StageGame")

---[[脚本]]----
--主控制器
BaseController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BaseController")
StageGameController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.StageGameController")
BatmanController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BatmanController")
BossController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Boss.BossController")

BulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.BulletController")---子弹控制器
EnemyBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.EnemyBulletController")
PlayerBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.PlayerBulletController")
WingmanBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.WingmanBulletController")

PlayerController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.PlayerController")---自机控制
ReimuController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.ReimuController")
MarisaController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.MarisaController")
PropController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.PropController")---道具控制
EmitterController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.EmitterController")---发射器控制器
WingmanController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Wingman.WingmanController")---僚机控制器
--其他
AutoRotationScript = require("Scripts.Context.Game.Modules.Stage.Script.Module.Function.AutoRotationScript")
TraceBulletScript = require("Scripts.Context.Game.Modules.Stage.Script.Module.Function.TraceBulletScript")

--生命控制
HealthController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.HealthController")
BatmanHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.BatmanHealth")
BossHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.BossHealth")
PlayerHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.PlayerHealth")
BulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.Bullet.BulletHealth")
PlayerBulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.Bullet.PlayerBulletHealth")
EnemyBulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.Bullet.EnemyBulletHealth")
WingmanBulletHealth = require("Scripts.Context.Game.Modules.Stage.Script.Module.Health.Bullet.WingmanBulletHealth")

--碰撞控制
CollisionController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.CollisionController")
PlayerCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.PlayerCollision")
BossCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.BossCollision")
BatmanCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.BatmanCollision")
PorpCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.PorpCollision")
---子弹的碰撞控制
BulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.Bullet.BulletCollision")
PlayerBulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.Bullet.PlayerBulletCollision")
EnemyBulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.Bullet.EnemyBulletCollision")
WingmanBulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.Bullet.WingmanBulletCollision")

--消弹系统
WipeController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Wipe.WipeController")
ReimuWipeController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Wipe.ReimuWipeController")
MarisaWipeController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Wipe.MarisaWipeController")
--能量系统
PowerController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Power.PowerController")
--擦弹系统
BrushController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Brush.BrushController")
--低速(人妖)系统
SlowController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Slow.SlowController")
ReimuSlowController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Slow.ReimuSlowController")
MarisaSlowController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Slow.MarisaSlowController")

--符卡(bomb)系统
SpellController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Spell.SpellController")
PlayerSpellController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Spell.PlayerSpellController")
EnemySpellController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Spell.EnemySpellController")
BossSpellController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Spell.BossSpellController")
--输入控制
InputController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Input.InputController")
PlayerInput = require("Scripts.Context.Game.Modules.Stage.Script.Module.Input.PlayerInput")

--动画控制
AnimationController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.AnimationController")
BatmanAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BatmanAnimation")
BossAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BossAnimation")
PlayerAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.PlayerAnimation")
WingmanAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.WingmanAnimation")
BulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BulletAnimation")
EnemyBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.EnemyBulletAnimation")
PlayerBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.PlayerBulletAnimation")
WingmanBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.WingmanBulletAnimation")
PropAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.PropAnimation")

--公共脚本
EntityBasedata = require("Scripts.Context.Game.Modules.Stage.Script.Public.EntityBasedata")
EntityController = require("Scripts.Context.Game.Modules.Stage.Script.Public.EntityController")
DestroyByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByBorder")
DestroyByTime = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByTime")
ConstraintByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.ConstraintByBorder")
ManageByPool = require("Scripts.Context.Game.Modules.Stage.Script.Public.ManageByPool")
----
StageEntityManager = require("Scripts.Context.Game.Modules.Stage.StageEntityManager") --实体管理
------
--[[轮询的系统注册]]---
THSTG.ECSManager.registerSystem("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")