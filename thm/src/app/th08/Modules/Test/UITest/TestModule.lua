module(..., package.seeall)

local M = class("TestModule", View)

local testUI = nil

function M:onCreate()
    local TestTb = {
        require("Modules.Test.UITest.UITest1"),     --按钮文字测试
        require("Modules.Test.UITest.UITest2"),     --View测试
        require("Modules.Test.UITest.UITest3"),     --菜单测试
    }
    --事件监听
    -- -- 注册键盘事件
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
            changeTest(keyCode - cc.KeyCode.KEY_1 + 1)
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
            end
        end,
    })
    THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    changeTest(1)
end

return M