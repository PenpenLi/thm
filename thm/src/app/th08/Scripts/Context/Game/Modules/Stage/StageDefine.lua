module("StageDefine", package.seeall)

--
Speed = require("Scripts.Context.Game.Modules.Stage.Entity.Base.Speed")
--
EntityData = require("Scripts.Context.Game.Modules.Stage.Entity.Data.EntityData")
LivedEntityData = require("Scripts.Context.Game.Modules.Stage.Entity.Data.LivedEntityData")
--
BaseState = require("Scripts.Context.Game.Modules.Stage.Entity.State.BaseState")
ShotState = require("Scripts.Context.Game.Modules.Stage.Entity.State.ShotState")
MoveState = require("Scripts.Context.Game.Modules.Stage.Entity.State.MoveState")
--
BaseEntity = require("Scripts.Context.Game.Modules.Stage.Entity.BaseEntity")
LivedEntity = require("Scripts.Context.Game.Modules.Stage.Entity.LivedEntity")
EnemyEntity = require("Scripts.Context.Game.Modules.Stage.Entity.EnemyEntity")
PlayerEntity = require("Scripts.Context.Game.Modules.Stage.Entity.PlayerEntity")

Reimu = require("Scripts.Context.Game.Modules.Stage.Entity.Reimu") 
----

ScenarioUtil = require("Scripts.Context.Game.Modules.Stage.Util.ScenarioUtil")
EntityUtil = require("Scripts.Context.Game.Modules.Stage.Util.EntityUtil")