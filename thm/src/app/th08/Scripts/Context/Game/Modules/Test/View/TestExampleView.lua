module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------
    local TEST_EXAMPLE_TABLE = {
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest0"),         --测试面板
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest1"),         --纹理测试
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest2"),         --动画测试
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest3"),         --特效测试
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest4"),         --控制测试
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest5"),         --对话框测试
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest6"),         --时间表测试
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest7"),         --特效测试
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest8"),         --图片效果测试
        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest9"),         --背景测试

        require("Scripts.Context.Game.Modules.Test.View.UITest.UITest10"),         --CC特效测试
        require("Scripts.Context.Game.Modules.Test.View.GameTest.GameScene"),         --图片效果测试
    }
    -------View-------
    local node = THSTG.UI.newNode()

    local function init()
        --事件监听
        --注册键盘事件
        local function changeTest(index)
            if TEST_EXAMPLE_TABLE[index] then
                if testUI then 
                    if not tolua.isnull(testUI) then
                        testUI:removeFromParent()
                    end
                end
                testUI = TEST_EXAMPLE_TABLE[index].create()
                node:addChild(testUI)
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
        THSTG.CCDispatcher:addEventListenerWithSceneGraphPriority(listener, node)

        -- changeTest(#TEST_EXAMPLE_TABLE)
        changeTest(1 + 1)
    end
    -------Controller-------
    node:onNodeEvent("enter", function ()
        
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node
end

return M