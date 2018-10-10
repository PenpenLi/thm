local M = class("MainScene", View)

function M:onCreate()
    --------Model--------
    
    --------View--------
    local function createTemplate()
        local node = THSTG.UI.newWidget()

        --
        function node:setState(data, pos)
            if data.__isClick == true then
                
            else
                
            end
        end

        function node:_onCellClick(data)
            if data.value.__isClick == true then
               
            else
                
            end
        end

        return node
    end
    --
    local layer = THSTG.UI.newLayer()
    self:addChild(layer)

     --背景图
     local mainBg = THSTG.UI.newImage({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        src = ResManager.getRes(ResType.MAIN_SCENE, "") --TODO:

    })


    local titleList = THSTG.UI.newTileList({
        x = 250,
        y = 250,
        width = 582, 
        height = 348, 
        -- itemWidth = 558,
        -- itemHeight = 94,
        anchorPoint = UI.POINT_CENTER_TOP,
        colCount = 1,
        -- itemRowGap = 10,
        itemColGap = 10,
        -- padding = {left= 0,right=0,top=0,bottom =5},
        direction = ccui.ListViewDirection.vertical,
        itemTemplate = createTemplate,

    })
    layer:addChild(titleList)
    debugUI(titleList)
    --------Control--------
    layer:onNodeEvent("enter", function ()
        
	end)

	layer:onNodeEvent("exit", function ()
        
    end)

end

return M