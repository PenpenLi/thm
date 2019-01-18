local M = class("PropController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)
 
end
---

function M:reset(refEntity)

end
---
function M:_onAdded(entity)
    M.super._onAdded(self,entity)
    
    entity:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
    entity:setActive(false)
end
---
function M:_onStart()
 
end

---


return M