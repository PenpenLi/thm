module(..., package.seeall)

local M = class("TestModule", View)

local testUI = nil

function M:onCreate()
    local TestTb = {
        require("Scripts.Game.Modules.Test.UITest.UITest0"),         --测试面板
        require("Scripts.Game.Modules.Test.UITest.UITest1"),         --动画测试
        require("Scripts.Game.Modules.Test.UITest.UITest2"),         --所有动画测试
        require("Scripts.Game.Modules.Test.UITest.UITest3"),         --背景测试
        require("Scripts.Game.Modules.Test.UITest.UITest4"),         --控制测试
        require("Scripts.Game.Modules.Test.UITest.UITest5"),         --对话框测试
        require("Scripts.Game.Modules.Test.UITest.UITest6"),         --时间表测试
        require("Scripts.Game.Modules.Test.UITest.UITest7"),         --特效测试
        require("Scripts.Game.Modules.Test.UITest.UITest8"),         --图片效果测试
    }
    --事件监听
    --注册键盘事件
    local function changeTest(index)
        if TestTb[index] then
            if testUI then 
                if not tolua.isnull(testUI) then
                    testUI:removeFromParent()
                end
            end
            testUI = TestTb[index].create()
            self:addChild(testUI)
        end
    end

    local listener = THSTG.EVENT.newKeyboardListener({
        onPressed = function(keyCode, event)
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
            else
                if keyCode >= cc.KeyCode.KEY_0 and keyCode <= cc.KeyCode.KEY_9 then
                    changeTest(keyCode - cc.KeyCode.KEY_0 + 1)
                end
            end
        end,
    })
    THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    -- changeTest(#TestTb)
    changeTest(8 + 1)
end

return M