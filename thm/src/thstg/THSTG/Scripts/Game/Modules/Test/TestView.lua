module(..., package.seeall)

local M = class("TestView", View)

local testUI = nil

function M:onCreate()
    local TestTb = {
        -- require("Scripts.Game.Modules.Test.UITest.UITestView"),      --UI测试
        -- require("Scripts.Game.Modules.Test.SceneTest.SceneTestView"),     --View测试
        require("Scripts.Game.Modules.Test.UITest.UITest0"),         --TabBar测试
        require("Scripts.Game.Modules.Test.UITest.UITest1"),         --按钮文字测试
        require("Scripts.Game.Modules.Test.UITest.UITest2"),         --View测试
        require("Scripts.Game.Modules.Test.UITest.UITest3"),         --菜单测试
        require("Scripts.Game.Modules.Test.UITest.UITest4"),         --TileList测试
        require("Scripts.Game.Modules.Test.UITest.UITest5"),         --Accordion测试
        require("Scripts.Game.Modules.Test.UITest.UITest6"),         --Box测试
        require("Scripts.Game.Modules.Test.UITest.UITest7"),         --Progress测试
        require("Scripts.Game.Modules.Test.UITest.UITest8"),         --Slider/Bar测试
        require("Scripts.Game.Modules.Test.UITest.UITest9"),         --RadioButton测试
  
        require("Scripts.Game.Modules.Test.SceneTest.SceneTest1"),   --动画测试
        require("Scripts.Game.Modules.Test.SceneTest.SceneTest2"),   --场景转换测试
        require("Scripts.Game.Modules.Test.SceneTest.SceneTest3"),   --跳跃测试
        require("Scripts.Game.Modules.Test.SceneTest.SceneTest4"),   --动作测试
        require("Scripts.Game.Modules.Test.SceneTest.SceneTest5"),   --计划任务测试
        -- require("Scripts.Game.Modules.Test.SceneTest.SceneTest6"),   --碰撞测试
        -- require("Scripts.Game.Modules.Test.SceneTest.SceneTest7"),   --特效测试
        -- require("Scripts.Game.Modules.Test.SceneTest.SceneTest8"),   --跟踪测试
        -- require("Scripts.Game.Modules.Test.SceneTest.SceneTest9"),   --粒子测试   
    }
    --事件监听
    --注册键盘事件
    local function changeTest(index)
        if TestTb[index] then
            if testUI then 
                testUI:removeFromParent()
            end
            testUI = TestTb[index].create()
            self:addChild(testUI)
        end
    end

    local listener = THSTG.EVENT.newKeyboardListener({
        onPressed = function(keyCode, event)
            changeTest(keyCode - cc.KeyCode.KEY_0 + 1)
            if keyCode == cc.KeyCode.KEY_Q then
                changeTest(11)
            elseif keyCode == cc.KeyCode.KEY_W then
                changeTest(12)
            elseif keyCode == cc.KeyCode.KEY_E then
                changeTest(13)
            elseif keyCode == cc.KeyCode.KEY_R then
                changeTest(14)
            elseif keyCode == cc.KeyCode.KEY_T then
                changeTest(15)
            elseif keyCode == cc.KeyCode.KEY_Y then
                changeTest(16)
            elseif keyCode == cc.KeyCode.KEY_U then
                changeTest(17)
            elseif keyCode == cc.KeyCode.KEY_I then
                changeTest(18)
            elseif keyCode == cc.KeyCode.KEY_O then
                changeTest(19)
            elseif keyCode == cc.KeyCode.KEY_P then
                changeTest(20)
            end
        end,
    })
    THSTG.CCEventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    changeTest(2)
end

return M