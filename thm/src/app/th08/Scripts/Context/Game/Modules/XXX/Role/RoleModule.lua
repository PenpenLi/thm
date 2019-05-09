module(..., package.seeall)
local M = class("RoleModule", Controller)

function M:_onView()

    local layer = cc.Layer:create()
    layer:addTo(THSTG.SceneManager.get(SceneType.MAIN))

    return layer

end

function M:_onInit()
 
end

return M