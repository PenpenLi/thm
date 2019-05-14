module(..., package.seeall)

local M = {}
function M.create(params)
    params = params or {}
    -------Model-------
    local _uiStatusLb = false
   
    -------View-------
    local node = THSTG.UI.newNode({
        width = display.width,
        height = display.height,
    })

    _uiStatusLb = THSTG.UI.newLabel({
        x = node:getContentSize().width/2,
        y = 30,
        text = "XXXXXXXXXXXXX",
        anchorPoint = THSTG.UI.POINT_CENTER,
        style = {
            color = THSTG.UI.getColorHtml('#ab1111'),
            size = THSTG.UI.FONT_SIZE_NORMAL,
        }
    })
    node:addChild(_uiStatusLb)

    local function init()
     
    end
    init()
    -------Controller-------
    node:onNodeEvent("enter", function ()
       
    end)

    node:onNodeEvent("exit", function ()
        
    end)
    
    return node
end

return M