module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

	-- local borderframe = THSTG.UI.newBorderFrame({
	-- 	{x = 30, y = 30, w = 440, h = 500, type = 1, style = 3},
	-- 	{x = 32, y = 480, w = 438, h = 2, type = 2, style = 3},
	-- 	{x = 480, y = 30, w = 450, h = 500, type = 1, style = 3},
	-- 	{x = 482, y = 480, w = 438, h = 2, type = 2, style = 3},
	-- })
	-- layer:addChild(borderframe)

	local lb = THSTG.UI.newLabel({
		text = "HBox",
		anchorPoint = THSTG.UI.POINT_CENTER,
		x = 250, y = 505
	})
	layer:addChild(lb)

	local lb = THSTG.UI.newLabel({
		text = "VBox",
		anchorPoint = THSTG.UI.POINT_CENTER,
		x = 700, y = 505
	})
	layer:addChild(lb)

	------------
	local hbox = THSTG.UI.newHBox({
		x = 100, y = display.cy,
		anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
		margin = 10,
		-- autoSize = true,
		linearGravity = ccui.LinearGravity.centerVertical
	})
	for i = 1, 3 do
		hbox:addChild(THSTG.UI.newButton({
			height = 50 * i,
			width = 100,
            text = "button"..i,
            style = {
                normal ={
                    skin = {
                        src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open")
                    }
                },
                selected = {
                    skin = {
                        src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
                    }
                },
            }
		}))
	end

	layer:addChild(hbox)

	local vbox = THSTG.UI.newVBox({
		x = display.cx + 100, y = display.cy,
		anchorPoint = THSTG.UI.POINT_LEFT_CENTER,
		-- autoSize = true,
		margin = 5,
		linearGravity = ccui.LinearGravity.centerHorizontal,
	})
	vbox:setBackGroundColorType(ccui.LayoutBackGroundColorType.solid)
	vbox:setBackGroundColor(THSTG.UI.COLOR_WHITE)
	for i = 1, 4 do
		local item = THSTG.UI.newButton({
			text = "button"..i,
			width = 50 + 50 * i,
            height = 40,
            style = {
                normal ={
                    skin = {
                        src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_open")
                    }
                },
                selected = {
                    skin = {
                        src = ResManager.getResSub(ResType.UI,UIType.BUTTON,"power1_close")
                    }
                },
            }
		})
		vbox:addChild(item)

	end

	layer:addChild(vbox)

	hbox:forceDoLayout()
	vbox:forceDoLayout()
	-- dump(vbox:getContentSize())
	-- dump(hbox:getContentSize())


    return layer
end
return M