module("THSTG.ColorStyleConfig", package.seeall)

local t_color_style = nil
function getColorType(key)
	if not t_color_style then
		t_color_style = require("thstg.Scripts.Game.Configs.Handwork.ColorStyle")
	end
	local color = t_color_style[key] or t_color_style.text_normal1
	if t_color_style[key] == nil then
	end
	return htmlColor2C3b(color)
end

function getColorTypeEx(key)
	if not t_color_style then
		t_color_style = require("thstg.Scripts.Game.Configs.Handwork.ColorStyle")
	end
	return t_color_style[key] or t_color_style.text_normal1
end