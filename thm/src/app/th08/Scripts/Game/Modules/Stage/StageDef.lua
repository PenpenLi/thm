module("StageDef", package.seeall)

--
Speed = require("Scripts.Game.Modules.Stage.Component.Entity.Base.Speed")
--
EntityData = require("Scripts.Game.Modules.Stage.Component.Entity.Data.EntityData")
LivedEntityData = require("Scripts.Game.Modules.Stage.Component.Entity.Data.LivedEntityData")
--
BaseState = require("Scripts.Game.Modules.Stage.Component.Entity.State.BaseState")
ShotState = require("Scripts.Game.Modules.Stage.Component.Entity.State.ShotState")
MoveState = require("Scripts.Game.Modules.Stage.Component.Entity.State.MoveState")
--
BaseEntity = require("Scripts.Game.Modules.Stage.Component.Entity.BaseEntity")
LivedEntity = require("Scripts.Game.Modules.Stage.Component.Entity.LivedEntity")
EnemyEntity = require("Scripts.Game.Modules.Stage.Component.Entity.EnemyEntity")
PlayerEntity = require("Scripts.Game.Modules.Stage.Component.Entity.PlayerEntity")

----