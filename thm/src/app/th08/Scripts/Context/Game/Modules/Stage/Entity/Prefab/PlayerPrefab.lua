module(..., package.seeall)
local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local M = class("PlayerPrefab",StageDefine.PlayerEntity)

function M:ctor(...)
    M.super.ctor(self)

    self.playerController = StageDefine.PlayerController.new()
    self:addScript(self.playerController)
    
    self.playerMove = StageDefine.PlayerMove.new()
    self:addScript(self.playerMove)
    


    ---
    self:_onInit(...)
    -- debugUI(self)

end


----------


return M