module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
   

    --------View--------
    local node = THSTG.UI.newNode()

    local function createLayer(params)
		-- local layer = THSTG.UI.newLayerColor(params)
        local layer = THSTG.UI.newLayer(params)
        local scrollView = UI.newScrollView({
            x = 0,
            y = 0,
            width = layer:getContentSize().width,
            height = layer:getContentSize().height,
            innerWidth = layer:getContentSize().width,
            innerHeight = layer:getContentSize().height,
            direction = ccui.ScrollViewDir.vertical,
        })
        layer:addChild(scrollView)

        local panel = THSTG.UI.newNode({
            x = 0,
            y = 0,
            width = layer:getContentSize().width,
            height = layer:getContentSize().height,
        })
        scrollView:addChild(panel)

        local type = params.type
        local lastPosX,lastPosY = 0,panel:getContentSize().height
        local curMaxHeight = 0
        local innerHeight = panel:getContentSize().height
        local dict = {}
        if type == TexType.SHEET then dict = SheetConfig.getSequenceDict() end

        for fileName,v in pairs(dict) do
            for keyName,vv in pairs(v) do
                local animation = ScenePublic.newAnimation({
                    texType = type, 
                    fileName = fileName,
                    keyName = keyName
                })
                local sprite = THSTG.UI.newSprite({
                    x = lastPosX,
                    y = lastPosY,
                    anchorPoint = THSTG.UI.POINT_LEFT_TOP
                })

                sprite:playAnimationForever(animation)
                panel:addChild(sprite)
                local spriteSize = animation:getFrames()[1]:getSpriteFrame():getOriginalSize()

                local clickNode = THSTG.UI.newWidget({
                    x = spriteSize.width/2,
                    y = spriteSize.height/2,
                    width = spriteSize.width,
                    height = spriteSize.height,
                    anchorPoint = THSTG.UI.POINT_CENTER,
                    onClick = function()
                        dump(0,vv.rect,keyName)
                    end,
                })
                sprite:addChild(clickNode)


                lastPosX = lastPosX + spriteSize.width
            
                if lastPosX >= panel:getContentSize().width then
                    lastPosX = 0
                    lastPosY = lastPosY - curMaxHeight
                    if lastPosY <= 0 then
                        innerHeight = innerHeight + curMaxHeight
                    end
                    
                    curMaxHeight = 0
                end
                curMaxHeight = math.max(curMaxHeight,spriteSize.height)
            end
        end

        scrollView:setInnerContainerSize(cc.size(scrollView:getContentSize().width,innerHeight))
        panel:setPositionY(innerHeight - panel:getContentSize().height)


		return layer
	end
    local layerStack = THSTG.UI.newLayerStack{
		layers = {
            {data = "Layer1", creator = createLayer, creatorParams = {type = TexType.SHEET,color = THSTG.UI.COLOR_RED, width = display.width, height = display.height - 50}},
			{data = "Layer2", creator = createLayer, creatorParams = {type = TexType.PLIST,color = THSTG.UI.COLOR_GREEN, width = display.width, height = display.height - 50}},
			{data = "Layer3", creator = createLayer, creatorParams = {type = TexType.IMAGE,color = THSTG.UI.COLOR_BLUE, width = display.width, height = display.height - 50}},
        }
	}
    node:addChild(layerStack)

    local tabBar = THSTG.UI.newTabBar({
        dataProvider = {
            "SHEET",
            "PLIST",
            "IMAGE",
        },
        style = {
            normal = {
                skin = {
                    src = ResManager.getUIRes(UIType.BUTTON,"btn_base_yellow")
                } 
            },
            pressed = {
                skin = {
                    src = ResManager.getUIRes(UIType.BUTTON,"btn_base_yellow")
                }
            },
            disabled = {
                skin = {
                    src = ResManager.getUIRes(UIType.BUTTON,"btn_base_yellow")
                } 
            },
        },
        x = 10, y = display.height,
        anchorPoint = THSTG.UI.POINT_LEFT_TOP,
        onChange = function(sender, curIndex, prevIndex)
            layerStack:setSelectedIndex(curIndex)
        end,
    })
    node:addChild(tabBar)

    --------Controller--------
  
    node:onNodeEvent("enter", function ()
       
	end)

	node:onNodeEvent("exit", function ()

    end)

    return node
end
return M