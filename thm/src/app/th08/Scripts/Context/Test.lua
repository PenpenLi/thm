------------------------------------------------------------------
--调试版本下的全局变量
------------------------------------------------------------------
--是否调试版本
__DEBUG__ = false
or true

--测试状态用来隐藏测试按钮
__HIDE_TEST__ = false
-- or true

--CC物理引擎的MASK
__PHYSICS_DEBUG_MASK__ = nil --cc.PhysicsWorld.DEBUGDRAW_ALL

--是否显示碰撞矩形
__SHOW_COLLIDER_DEBUG__ = false
-- or true

------
--每个人定义一个自己的类型，用于屏蔽其他人写的打印log，为0时打印所有
THSTG.__PRINT_TYPE__ = 0

--调用print时是否显示文件和等号
THSTG.__PRINT_WITH_FILE_LINE__ = false

--------------------------------------------------
