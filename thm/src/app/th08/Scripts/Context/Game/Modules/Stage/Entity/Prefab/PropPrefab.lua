module(..., package.seeall)

local M = class("PropPrefab",StageDefine.MovableEntity)

function M:ctor()
    M.super.ctor(self)

    self:setName("PROP")

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)
    
    self.propController = StageDefine.PropController.new()
    self:addScript(self.propController)

    --
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
end

----------


return M