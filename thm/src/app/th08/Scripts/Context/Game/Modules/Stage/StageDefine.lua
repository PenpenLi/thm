module("StageDefine", package.seeall)

---[[组件]]----
SpriteComponent = THSTG.ECS.SpriteComponent
AnimationComponent = THSTG.ECS.AnimationComponent
TransformComponent = THSTG.ECS.TransformComponent
ActionComponent = THSTG.ECS.ActionComponent
InputComponent = THSTG.ECS.InputComponent
RigidbodyComponent = THSTG.ECS.RigidbodyComponent
AudioComponent = THSTG.ECS.AudioComponent
SchedulerComponent = THSTG.ECS.SchedulerComponent
BoxColliderComponent = THSTG.ECS.BoxColliderComponent
CircleColliderComponent = THSTG.ECS.CircleColliderComponent

----

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

HealthBarPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Base.UI.HealthBarPrefab")

--发射口预制体
EmitterPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.EmitterPrefab")

--Batman预制体
Fairy01Prefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Batman.Fairy01Prefab")

--Bullet预制体
ReimuBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Bullet.Player.ReimuBulletPrefab")
OnmyouGyokuBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Bullet.Player.OnmyouGyokuBulletPrefab")

BigJadePrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Bullet.Enemy.BigJadePrefab")

--Boss预制体
WrigglePrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Boss.WrigglePrefab")

OnmyouGyoku = require("Scripts.Context.Game.Modules.Stage.Entity.OnmyouGyoku")
Reimu = require("Scripts.Context.Game.Modules.Stage.Entity.Reimu")
Marisa = require("Scripts.Context.Game.Modules.Stage.Entity.Marisa")
StageGame = require("Scripts.Context.Game.Modules.Stage.Entity.StageGame")

---[[脚本]]----
--主控制器
BaseController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.BaseController")
---舞台控制器
StageGameController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Stage.StageGameController")
---
BatmanController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Batman.BatmanController")

---Boss控制器
BossController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Boss.BossController")
WriggleController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Boss.WriggleController")

---子弹控制器
BulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.BulletController")
EnemyBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.EnemyBulletController")
PlayerBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.PlayerBulletController")
ReimuBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.ReimuBulletController")
MarisaBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.MarisaBulletController")
OnmyouGyokuBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.OnmyouGyokuBulletController")

---自机控制
PlayerController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.PlayerController")
ReimuController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.ReimuController")
MarisaController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.MarisaController")
---道具控制
PropController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Prop.PropController")
---发射器控制器
EmitterController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Emitter.EmitterController")
---僚机控制器
WingmanController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Wingman.WingmanController")
OnmyouGyokuController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Wingman.OnmyouGyokuController")

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
PorpCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.PorpCollision")
---子弹的碰撞控制
BulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.Bullet.BulletCollision")
PlayerBulletCollision = require("Scripts.Context.Game.Modules.Stage.Script.Module.Collision.Bullet.PlayerBulletCollision")
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
BossAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Boss.BossAnimation")
WriggleAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Boss.WriggleAnimation")

PlayerAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Player.PlayerAnimation")

WingmanAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Wingman.WingmanAnimation")
OnmyouGyokuAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Wingman.OnmyouGyokuAnimation")

BulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.BulletAnimation")
EnemyBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.EnemyBulletAnimation")
PlayerBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.PlayerBulletAnimation")
ReimuBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.ReimuBulletAnimation")
MarisaBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.MarisaBulletAnimation")
OnmyouGyokuBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.OnmyouGyokuBulletAnimation")

PropAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Prop.PropAnimation")

--公共脚本
DestroyByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByBorder")
DestroyByTime = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByTime")
ConstraintByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.ConstraintByBorder")

--全局脚本
EntityManager = require("Scripts.Context.Game.Modules.Stage.Script.EntityManager")

---[[工具]]-----
AnimationUtil = require("Scripts.Context.Game.Modules.Stage.Util.AnimationUtil")  
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  



------
--[[轮询的系统注册]]---
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.PhysicsSystem")
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.InputSystem")