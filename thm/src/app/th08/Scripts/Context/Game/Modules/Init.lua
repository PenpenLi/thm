
require("Scripts.Context.Game.Modules.Stage.StageDefine")



------------------
--模块注册
THSTG.MVCManager.registerModule(ModuleType.TEST, "Scripts.Context.Game.Modules.Test.TestModule")
THSTG.MVCManager.registerModule(ModuleType.EDITOR, "Scripts.Context.Game.Modules.Editor.EditorModule")
THSTG.MVCManager.registerModule(ModuleType.MENU, "Scripts.Context.Game.Modules.Menu.MenuModule")
THSTG.MVCManager.registerModule(ModuleType.STAGE, "Scripts.Context.Game.Modules.Stage.StageModule")
-- THSTG.ModuleManager.register(ModuleType.ROLE, "Scripts.Context.Game.Modules.Role.RoleModule")
-- THSTG.ModuleManager.register(ModuleType.LOADING, "Scripts.Context.Game.Modules.Loading.LoadingController")
-- THSTG.ModuleManager.register(ModuleType.SELECTION, "Scripts.Context.Game.Modules.Selection.SelectionController")
