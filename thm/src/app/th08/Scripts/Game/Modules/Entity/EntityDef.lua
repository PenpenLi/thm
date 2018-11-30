module("EntityDef", package.seeall)


--
Speed = require("Scripts.Game.Modules.Entity.Base.Speed")
--
EntityData = require("Scripts.Game.Modules.Entity.Data.EntityData")
LivedEntityData = require("Scripts.Game.Modules.Entity.Data.LivedEntityData")
--
BaseState = require("Scripts.Game.Modules.Entity.State.BaseState")
PlayerState = require("Scripts.Game.Modules.Entity.State.PlayerState")
PlayerShotState = require("Scripts.Game.Modules.Entity.State.PlayerShotState")
PlayerMoveState = require("Scripts.Game.Modules.Entity.State.PlayerMoveState")
--
BaseEntity = require("Scripts.Game.Modules.Entity.BaseEntity")
LivedEntity = require("Scripts.Game.Modules.Entity.LivedEntity")
EnemyEntity = require("Scripts.Game.Modules.Entity.EnemyEntity")
PlayerEntity = require("Scripts.Game.Modules.Entity.PlayerEntity")

----