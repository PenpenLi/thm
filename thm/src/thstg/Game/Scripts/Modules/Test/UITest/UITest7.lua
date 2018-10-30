module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayerColor({
        color = { r =115,g=115,b=115}
    })

    local centerX = display.cx 
    local centerY = display.cy 
    local progressBar = THSTG.UI.newProgressBar({
        x = centerX,
        y = centerY,
        width = 420,
        height = 20,
        anchorPoint = THSTG.UI.POINT_CENTER,
        showLabel = true,
        isCanOverMaxValue = true,           --能够超过最大值显示
        -- labelOffsetX = 300,
        -- labelOffsetY = 12,
        style = {
            -- labelAnchorPoint = THSTG.UI.POINT_RIGHT_BOTTOM,
            label = THSTG.UI.newTextStyle({
                anchorPoint = THSTG.UI.POINT_RIGHT_BOTTOM,
                size = THSTG.UI.FONT_SIZE_SMALLER,
                color = THSTG.UI.getColorHtml("#ffffff"),
                outline = 1,
                outlineColor = THSTG.UI.getColorHtml("#b25d32"),
            }),
            bgSkin = {
                src = "Assets/UI/ProgressBar/prog_bar_bg2.png", 
                scale9Rect = {left=5, right=5, top=5, bottom=5}
            },
            progressSkin = {
                src = "Assets/UI/ProgressBar/prog_bar_item2.png", 
                scale9Rect = {left=5, right=5, top=5, bottom=5}
            }
        },
        -- 中间文字格式
        labelFormater = function (value, maxValue)
            return string.format("%s/%s", value, maxValue)
        end,
    })
    layer:addChild(progressBar)

    progressBar:refresh(1200,100)


    --    
    local progressBar = THSTG.UI.newProgressBar({
        x = centerX,
        y = centerY-40,
        width = 420,
        height = 20,
        anchorPoint = THSTG.UI.POINT_CENTER,
        showLabel = true,
        isCanOverMaxValue = true,           --能够超过最大值显示
        -- labelOffsetX = 300,
        -- labelOffsetY = 12,
        style = {
            -- labelAnchorPoint = THSTG.UI.POINT_RIGHT_BOTTOM,
            label = THSTG.UI.newTextStyle({
                anchorPoint = THSTG.UI.POINT_RIGHT_BOTTOM,
                size = THSTG.UI.FONT_SIZE_SMALLER,
                color = THSTG.UI.getColorHtml("#ffffff"),
                outline = 1,
                outlineColor = THSTG.UI.getColorHtml("#b25d32"),
            }),
            bgSkin = false,
            progressSkin = {
                src = "Assets/UI/ProgressBar/prog_bar_item2.png", 
                scale9Rect = {left=5, right=5, top=5, bottom=5}
            }
        },
        -- 中间文字格式
        labelFormater = function (value, maxValue)
            return string.format("%s/%s", value, maxValue)
        end,
    })
    layer:addChild(progressBar)
    progressBar:setMaxValue(1680)
    progressBar:setValue(88)

    --
    local time = 0
    local progressBar = THSTG.UI.newProgressBar({
        x = centerX,
        y = centerY-80,
        width = 420,
        height = 20,
        anchorPoint = THSTG.UI.POINT_CENTER,
        showLabel = true,
        isCanOverMaxValue = true,           --能够超过最大值显示
        -- labelOffsetX = 300,
        -- labelOffsetY = 12,
        style = {
            -- labelAnchorPoint = THSTG.UI.POINT_RIGHT_BOTTOM,
            label = THSTG.UI.newTextStyle({
                anchorPoint = THSTG.UI.POINT_RIGHT_BOTTOM,
                size = THSTG.UI.FONT_SIZE_SMALLER,
                color = THSTG.UI.getColorHtml("#ffffff"),
                outline = 1,
                outlineColor = THSTG.UI.getColorHtml("#b25d32"),
            }),
            bgSkin = {
                src = "Assets/UI/ProgressBar/prog_bar_bg2.png", 
                scale9Rect = {left=5, right=5, top=5, bottom=5}
            },
            progressSkin = {
                src = "Assets/UI/ProgressBar/prog_bar_item2.png", 
                scale9Rect = {left=5, right=5, top=5, bottom=5}
            }
        },
        -- 中间文字格式
        labelFormater = function (value, maxValue)
            return string.format("%s/%s", value, maxValue)
        end,
    })
    layer:addChild(progressBar)
    progressBar:setMaxValue(100)
    progressBar:setValue(0)
    local s1 
    s1 = THSTG.Scheduler.schedule(function()
        time = time + 1
        progressBar:setValue(time)
        if time >= 100 then 
            THSTG.Scheduler.unschedule(s1)
            s1 = nil
        end
    end, 1/20)

    --节点退出时移除定时器
    layer:onNodeEvent("exit", function ()
        if s1 then
            THSTG.Scheduler.unschedule(s1)
        end
    end)


	Scheduler.scheduleNextFrame(function()
		local radialProgBar = THSTG.UI.newRadialProgressBar({
			x = display.cx,
			y = display.cy,
            offset = 90,
            style = {
                bgSkin = {
                    src = ResManager.getUIRes(UIType.PROGRESSBAR,"prog_radial_bg")
                },
                progressSkin = {
                    src = ResManager.getUIRes(UIType.PROGRESSBAR,"prog_radial_hp")
                }
            }
		})
		layer:addChild(radialProgBar)
		radialProgBar:progressFromTo(5,0,90)
	end)

    return layer
end
return M