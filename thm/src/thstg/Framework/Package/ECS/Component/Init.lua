Script = require "thstg.Framework.Package.ECS.Component.ScriptComponent"

SpriteComponent = require("thstg.Framework.Package.ECS.Component.SpriteComponent")
AnimationComponent = require("thstg.Framework.Package.ECS.Component.AnimationComponent")
TransformComponent = require("thstg.Framework.Package.ECS.Component.TransformComponent")
ActionComponent = require("thstg.Framework.Package.ECS.Component.ActionComponent")
InputComponent = require("thstg.Framework.Package.ECS.Component.InputComponent")
AudioComponent = require("thstg.Framework.Package.ECS.Component.AudioComponent")

--物理组件
RigidbodyComponent = require("thstg.Framework.Package.ECS.Component.Physics.RigidbodyComponent")
BoxColliderComponent = require("thstg.Framework.Package.ECS.Component.Physics.Collider.BoxColliderComponent")
CircleColliderComponent = require("thstg.Framework.Package.ECS.Component.Physics.Collider.CircleColliderComponent")

--CC的物理组件
CCBoxRigidbodyComponent = require("thstg.Framework.Package.ECS.Component.CCPhysics.CCBoxRigidbodyComponent")
CCCircleRigidbodyComponent = require("thstg.Framework.Package.ECS.Component.CCPhysics.CCCircleRigidbodyComponent")