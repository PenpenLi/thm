module(..., package.seeall)
local SelectDifficultyLayer = require("Modules.MainUi.MainMenu.StartItem.Layer.SelectDifficultyLayer")
local SelectRoleLayer = require("Modules.MainUi.MainMenu.StartItem.Layer.SelectRoleLayer")
local M = {}
function M.create(params)
    --------Model--------
    local _varMoveBy = nil

    local _selectedClickHandle = nil
    --------View--------
    local node = THSTG.SCENE.newScene()


    
    local _selectDiff = SelectDifficultyLayer.create({
        onClick = function(sender)
            return _selectedClickHandle(sender)
        end
    })
    node:addChild(_selectDiff)

    -- local _selectRole = SelectRoleLayer.create()
    -- _selectRole:setVisible(false)
    -- node:addChild(_selectRole)

    --------Control--------
    _selectedClickHandle = function(sender)
        if sender then
            --TODO:位置不对
            local destPos = cc.p(400,80)
            local srcPos = sender:convertToWorldSpace(cc.p(sender:getPosition()))
            local moveVec2 = cc.p(destPos.x - srcPos.x,destPos.y - srcPos.y)
            _varMoveBy = cc.MoveTo:create(0.3,moveVec2)
            sender:runAction(_varMoveBy)
        end
    end

    node:onNodeEvent("enter", function ()
       
	end)

	node:onNodeEvent("exit", function ()
        
    end)



    return node
end
return M