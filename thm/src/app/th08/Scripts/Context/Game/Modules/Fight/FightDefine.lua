module("FightDefine", package.seeall)

--
Speed = require("Scripts.Context.Game.Modules.Fight.Entity.Base.Speed")
--
EntityData = require("Scripts.Context.Game.Modules.Fight.Entity.Data.EntityData")
LivedEntityData = require("Scripts.Context.Game.Modules.Fight.Entity.Data.LivedEntityData")
--
BaseState = require("Scripts.Context.Game.Modules.Fight.Entity.State.BaseState")
ShotState = require("Scripts.Context.Game.Modules.Fight.Entity.State.ShotState")
MoveState = require("Scripts.Context.Game.Modules.Fight.Entity.State.MoveState")
--
BaseEntity = require("Scripts.Context.Game.Modules.Fight.Entity.BaseEntity")
LivedEntity = require("Scripts.Context.Game.Modules.Fight.Entity.LivedEntity")
EnemyEntity = require("Scripts.Context.Game.Modules.Fight.Entity.EnemyEntity")
PlayerEntity = require("Scripts.Context.Game.Modules.Fight.Entity.PlayerEntity")

Reimu = require("Scripts.Context.Game.Modules.Fight.Entity.Reimu") 
----

ScenarioUtil = require("Scripts.Context.Game.Modules.Fight.Util.ScenarioUtil")
EntityUtil = require("Scripts.Context.Game.Modules.Fight.Util.EntityUtil")