module("EVENT", package.seeall)

--SCENE_MANAGER
SCENEMGR_REPLACE = UIDUtil.getEventUID()
SCENEMGR_PUSH = UIDUtil.getEventUID()
SCENEMGR_POP = UIDUtil.getEventUID()
SCENEMGR_CHANGED = UIDUtil.getEventUID()

--MVC模块
MVC_MODULE_OPENED = UIDUtil.getEventUID()
MVC_MODULE_CLOSED = UIDUtil.getEventUID()
MVC_OPEN_MODULE = UIDUtil.getEventUID()
MVC_CLOSE_MODULE = UIDUtil.getEventUID()

--ECS模块
ECS_ENTITY_ADDED = UIDUtil.getEventUID()
ECS_ENTITY_DESTROY = UIDUtil.getEventUID()
ECS_ENTITY_REMOVED = UIDUtil.getEventUID()
ECS_ENTITY_CLEANUP = UIDUtil.getEventUID()
ECS_SYSTEM_ADDED = UIDUtil.getEventUID()
ECS_SYSTEM_REMOVEd = UIDUtil.getEventUID()