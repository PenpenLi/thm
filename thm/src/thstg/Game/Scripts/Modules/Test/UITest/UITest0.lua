module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()


    local layerData = {}
    local function createLayer(params)
		local layer = THSTG.UI.newLayerColor(params)
		layer:setPosition(math.random(0, display.cx), math.random(0, display.cy))

		local function nodeEventHandler(state)
			printf("~~~~~~~LayerStack layer %s~~~~~~~~~:%s", state, tostring(layer))
		end
		layer:registerScriptHandler(nodeEventHandler)

		return layer
	end
    local layerStack = THSTG.UI.newLayerStack{
		layers = {
            {data = "Layer1", creator = createLayer, creatorParams = {color = THSTG.UI.COLOR_RED, width = 100, height = 100}},
			{data = "Layer2", creator = createLayer, creatorParams = {color = THSTG.UI.COLOR_GREEN, width = 100, height = 150}},
			{data = "Layer3", creator = createLayer, creatorParams = {color = THSTG.UI.COLOR_BLUE, width = 200, height = 100}},
			{data = "Layer4", creator = createLayer, creatorParams = {color = THSTG.UI.COLOR_WHITE, width = 100, height = 200}},
			{data = "Layer5", creator = createLayer, creatorParams = {color = THSTG.UI.COLOR_BLACK, width = 300, height = 300}},
        }
	}
    layer:addChild(layerStack)

    local function onChange(sender, curIndex, prevIndex)
        --printf("~~~222~~~ sender:%s curIndex:%s prevIndex:%s", tostring(sender), tostring(curIndex), tostring(prevIndex))
        layerStack:setSelectedIndex(curIndex)
    end
    local function onChange1(sender, curIndex, prevIndex)
        printf("~~~333~~~ sender:%s curIndex:%s prevIndex:%s", tostring(sender), tostring(curIndex), tostring(prevIndex))
        layerStack:setSelectedIndex(curIndex)
    end
    local tabBar = THSTG.UI.newTabBar({
        dataProvider = {
            "标签一",
            "标签二",
            "标签三",
            "标签四",
        },
        style = {
            normal = {
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
                } 
            },
            pressed = {
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open") 
                }
            },
            disabled = {
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
                } 
            },
        },
        x = display.cx, y = display.cy + 180,
        onChange = onChange1,
    })
    layer:addChild(tabBar)

    local tabBarVR = THSTG.UI.newTabBar({
        dataProvider = {
            "标\n签\n一",
            "标\n签\n二",
            "标\n签\n三",
            "标\n签\n四",
        },
        style = {
            normal = {
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
                } 
            },
            pressed = {
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open") 
                }
            },
            disabled = {
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
                } 
            },
        },
        x = display.cx + 300, y = display.cy,
        onChange = onChange,
        direction = THSTG.UI.TABBAR_DIRECTION_VR,
    })
    layer:addChild(tabBarVR)

    local tabBarVL = THSTG.UI.newTabBar({
        dataProvider = {
            "美\n好\n1",
            "美\n好\n2",
            "美\n好\n3",
            "美\n好\n4",
        },
        style = {
            normal = {
                normal = {label = {artFont = "arial"}},
                skin = {src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")}
            },
            pressed = {
                label = {color = THSTG.UI.COLOR_RED},
                skin = {src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open")}
            },
            disabled = {
                skin = {src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")}
            },
        },
        x = display.cx - 300, y = display.cy-40,
        onChange = onChange,
        direction = THSTG.UI.TABBAR_DIRECTION_VL,

    })
    layer:addChild(tabBarVL)

    local tabBarHB = THSTG.UI.newTabBar({
        dataProvider = {
            "美好1",
            "美好2",
            "美好3",
            "美好4",
        },
        style = {
            normal = {
                label = {artFont =  "arial"},
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")

                } 
            },
            pressed = {
                label = {color = THSTG.UI.COLOR_RED},
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open") 
                }
            },
            disabled = {
                skin = {
                    src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
                } 
            },
        },
        x = display.cx, y = display.cy - 200,
        --x=200, y= 100,
        width = 300,
        onChange = onChange,
        direction = THSTG.UI.TABBAR_DIRECTION_HB,
        anchorPoint = THSTG.UI.POINT_CENTER,

    })
    layer:addChild(tabBarHB)



    return layer
end
return M