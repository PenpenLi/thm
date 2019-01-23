module("StageDefine", package.seeall)

---[[组件]]----
SpriteComponent = require("Scripts.Context.Game.Modules.Stage.Component.SpriteComponent")
AnimationComponent = require("Scripts.Context.Game.Modules.Stage.Component.AnimationComponent")
TransformComponent = require("Scripts.Context.Game.Modules.Stage.Component.TransformComponent")
ActionComponent = require("Scripts.Context.Game.Modules.Stage.Component.ActionComponent")
InputComponent = require("Scripts.Context.Game.Modules.Stage.Component.InputComponent")
RigidbodyComponent = require("Scripts.Context.Game.Modules.Stage.Component.RigidbodyComponent")
AudioComponent = require("Scripts.Context.Game.Modules.Stage.Component.AudioComponent")
SchedulerComponent = require("Scripts.Context.Game.Modules.Stage.Component.SchedulerComponent")
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

BatmanPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BatmanPrefab")

PlayerPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.PlayerPrefab")
EmitterPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.EmitterPrefab")
WingmanPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.WingmanPrefab")

BulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BulletPrefab")
EnemyBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.EnemyBulletPrefab")
PlayerBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.PlayerBulletPrefab")
ReimuBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Bullet.ReimuBulletPrefab")
OnmyouGyokuBulletPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Bullet.OnmyouGyokuBulletPrefab")

BossPrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.BossPrefab")
WrigglePrefab = require("Scripts.Context.Game.Modules.Stage.Entity.Prefab.Boss.WrigglePrefab")

OnmyouGyoku = require("Scripts.Context.Game.Modules.Stage.Entity.OnmyouGyoku")
Reimu = require("Scripts.Context.Game.Modules.Stage.Entity.Reimu")
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
OnmyouGyokuBulletController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Bullet.OnmyouGyokuBulletController")

---自机控制
PlayerController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.PlayerController")
ReimuController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Player.ReimuController")
---道具控制
PropController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Prop.PropController")
---发射器控制器
EmitterController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Emitter.EmitterController")
---僚机控制器
WingmanController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Wingman.WingmanController")
OnmyouGyokuController = require("Scripts.Context.Game.Modules.Stage.Script.Module.Controller.Wingman.OnmyouGyokuController")

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
BatmanAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.BatmanAnimation")
BossAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Boss.BossAnimation")
WriggleAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Boss.WriggleAnimation")

PlayerAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Player.PlayerAnimation")
ReimuAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Player.ReimuAnimation")

BulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.BulletAnimation")
EnemyBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.EnemyBulletAnimation")
PlayerBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.PlayerBulletAnimation")
ReimuBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.ReimuBulletAnimation")
OnmyouGyokuBulletAnimation = require("Scripts.Context.Game.Modules.Stage.Script.Module.Animation.Bullet.OnmyouGyokuBulletAnimation")

--公共脚本
DestroyByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByBorder")
DestroyByTime = require("Scripts.Context.Game.Modules.Stage.Script.Public.DestroyByTime")
ConstraintByBorder = require("Scripts.Context.Game.Modules.Stage.Script.Public.ConstraintByBorder")

---[[工具]]-----
AnimationUtil = require("Scripts.Context.Game.Modules.Stage.Util.AnimationUtil")  
ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")  



------
--[[轮询的系统注册]]---
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.CollisionSystem")
THSTG.ECS.System.register("Scripts.Context.Game.Modules.Stage.System.PhysicsSystem")
