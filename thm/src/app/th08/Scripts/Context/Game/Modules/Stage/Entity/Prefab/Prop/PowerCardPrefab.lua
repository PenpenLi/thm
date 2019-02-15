module(..., package.seeall)

local M = class("PowerCardPrefab",StageDefine.PropPrefab)

function M:ctor()
    M.super.ctor(self)

    --
    self:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
end

----------


return M