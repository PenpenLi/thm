module("THSTG.UI", package.seeall)

--默认皮肤
BUTTON_DEFAULT_PARAMS = {
	text = "",
	x = 0,
	y = 0,
	width = 0,
	height = 0,
	anchorPoint = POINT_CENTER,
	zoomScale = 0.1,
	enabled = true,
	style = {
		normal = {
			label = newTextStyle({
				size = FONT_SIZE_SMALL,
				color = getColorHtml("#ffffff"),
				outline = 1,
				outlineColor = getColorHtml("#f0e6a9"),
			}),
			skin = {
				src = "",
				scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
			}
		},
		selected = {
			label = newTextStyle({
				size = FONT_SIZE_SMALL,
				color = getColorHtml("#ffffff"),
				outline = 1,
				outlineColor = getColorHtml("#f0e6a9"),
			}),
			skin = {
				src = "",
				scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
			}
		},
		disabled = {
			label = newTextStyle({
				size = FONT_SIZE_SMALL,
				color = getColorHtml("#5c5c5a"),
				outline = 1,
				outlineColor = getColorHtml("#cdc8c8"),
			}),
			skin = {
				src = "",
				scale9Rect = {left = 0, right = 0, top = 0, bottom = 0}
			}
		},
	}
}

yellowStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_SMALL,
			color = getColorHtml("#6c3e26"),
			outline = 1,
			outlineColor = getColorHtml("#f0e6a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_base_yellow"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_SMALL,
			color = getColorHtml("#6c3e26"),
			outline = 1,
			outlineColor = getColorHtml("#f0e6a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_base_yellow"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_SMALL,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}

blueStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_SMALL,
			color = getColorHtml("#1f3057"),
			outline = 1,
			outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_base_blue"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_SMALL,
			color = getColorHtml("#1f3057"),
			outline = 1,
			outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_base_blue"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_SMALL,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_base_blue"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}

bigYellowStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#6d6833"),
			outline = 1,
			outlineColor = getColorHtml("#f0e6a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_big_yellow"),
			-- scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#6d6833"),
			outline = 1,
			outlineColor = getColorHtml("#f0e6a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_big_yellow"),
			-- scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
}

bigBlueStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#334c6d"),
			outline = 1,
			outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_big_blue"),
			-- scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#334c6d"),
			outline = 1,
			outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_big_blue"),
			-- scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
}

biggestYellowStyle = {
	normal = {
		label = newTextStyle({
			size = 28,
			color = getColorHtml("#6d6833"),
			outline = 1,
			outlineColor = getColorHtml("#f0e6a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_big_yellow"),
			-- scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
	selected = {
		label = newTextStyle({
			size = 28,
			color = getColorHtml("#6d6833"),
			outline = 1,
			outlineColor = getColorHtml("#f0e6a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_big_yellow"),
			-- scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
	disabled = {
		label = newTextStyle({
			size = 28,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
}

biggestBlueStyle = {
	normal = {
		label = newTextStyle({
			size = 28,
			color = getColorHtml("#334c6d"),
			outline = 1,
			outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_big_blue"),
			-- scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
	selected = {
		label = newTextStyle({
			size = 28,
			color = getColorHtml("#334c6d"),
			outline = 1,
			outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_big_blue"),
			-- scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
	disabled = {
		label = newTextStyle({
			size = 28,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {bottom = 30, left = 60, right = 60, top = 30},
		}
	},
}


yellowExStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#6c3e26"),
			outline = 1,
			outlineColor = getColorHtml("#f0e6a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_login_enter"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#6c3e26"),
			outline = 1,
			outlineColor = getColorHtml("#f0e6a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_login_enter"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}

blueExStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#1f3057"),
			outline = 1,
			outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getRes(ResType.NEWBIE, "vip_button"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#1f3057"),
			outline = 1,
			outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getRes(ResType.NEWBIE, "vip_button"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}


yellowFlowerStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#fefefe"),
			outline = 1,
			outlineColor = getColorHtml("#8b0922"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_flower_yellow"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#fefefe"),
			outline = 1,
			outlineColor = getColorHtml("#8b0922"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_flower_yellow"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}

flowerStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#852600"),
			outline = 1,
			outlineColor = getColorHtml("#ffe1a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_flower"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#852600"),
			outline = 1,
			outlineColor = getColorHtml("#ffe1a9"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_flower"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_BIG,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}



blueFlowerStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_NORMAL,
			color = getColorHtml("#1f3057"),
		outline = 1,
		outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_flower_blue"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_NORMAL,
			color = getColorHtml("#1f3057"),
		outline = 1,
		outlineColor = getColorHtml("#aac4d2"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_flower_blue"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_NORMAL,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}


greenFlowerStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#fefefe"),
			outline = 1,
			outlineColor = getColorHtml("#8b0922"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_flower_green"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#fefefe"),
			outline = 1,
			outlineColor = getColorHtml("#8b0922"),
		}),
		skin = {
			-- src = ResManager.getUIRes(UIType.BUTTON, "btn_flower_green"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}

activityStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#394847"),
			outline = 1,
			outlineColor = getColorHtml("#efefcb"),
		}),
		skin = {
			-- src = ResManager.getRes(ResType.ACTIVITY, "celebration_yellow_btn"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#394847"),
			outline = 1,
			outlineColor = getColorHtml("#efefcb"),
		}),
		skin = {
			-- src = ResManager.getRes(ResType.ACTIVITY, "celebration_yellow_btn"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_BIGGER,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}

activitySmallStyle = {
	normal = {
		label = newTextStyle({
			size = FONT_SIZE_NORMAL,
			color = getColorHtml("#4d2200"),
			outline = 1,
			outlineColor = getColorHtml("#ffdf99"),
		}),
		skin = {
			-- src = ResManager.getRes(ResType.ACTIVITY, "celebration_small_yellow_btn"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	selected = {
		label = newTextStyle({
			size = FONT_SIZE_NORMAL,
			color = getColorHtml("#4d2200"),
			outline = 1,
			outlineColor = getColorHtml("#ffdf99"),
		}),
		skin = {
			-- src = ResManager.getRes(ResType.ACTIVITY, "celebration_small_yellow_btn"),
			-- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
	disabled = {
		label = newTextStyle({
			size = FONT_SIZE_NORMAL,
			color = getColorHtml("#5c5c5a"),
			outline = 1,
			outlineColor = getColorHtml("#cdc8c8"),
		}),
		skin = {
			src = "",
			scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
		}
	},
}

activityBigStyle = 
{
    normal = {
        label = newTextStyle({
        	size = FONT_SIZE_BIGGER,
                color = getColorHtml("#4d2200"),
                outline = 1,
	            outlineColor = getColorHtml("#ffdf99"),
            }),
        skin = {
            -- src = ResManager.getRes(ResType.ACTIVITY, "celebration_yellow_btn"),
            -- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
        }
    },
    selected = {
        label = newTextStyle({
            size = FONT_SIZE_BIGGER,
            color = getColorHtml("#4d2200"),
            outline = 1,
	        outlineColor = getColorHtml("#ffdf99"),
        }),
        skin = {
            -- src = ResManager.getRes(ResType.ACTIVITY, "celebration_yellow_btn"),
            -- scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
        }
    },
    disabled = {
        label = newTextStyle({
        	size = FONT_SIZE_BIGGER,
        	color = getColorHtml("#5c5c5a"),
       	}),
        skin = {
          	src = "",
           	scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}
        }
    },
}



--[[
创建Button

@notice button 的背景图片大小需一致否则，拉伸区域会与预期输入不符。因为button默认拉伸区域取第一张图的。效率问题暂时不改button实现，如需要可以独立修改各状态背景

params中可用参数：
@param	text		[string]	按钮上的文字
@param	x			[number]	x坐标
@param	y			[number]	y坐标
@param	width		[number]	宽度
@param	height		[number]	高度
@param	anchorPoint	[cc.p]		锚点(如UI.POINT_CENTER)
@param	tag			[number]	tag标识
@param	enabled		[boolean]	是否可用, 为false时显示为disabled状态
@param	zoomScale	[number]	点击放大倍数, 最终scale = scale + zoomScale, 默认值0.1
@param  isTouchAction [bool]    是否点击动画
@param	onTouch		[function]	点击回调函数(按钮上执行的各种事件)
@param	onClick		[function]	点击回调函数(在按钮上按下并且松开)
@param  isBlueStyle [boolean]   橙色风格
@param	style		[table]		样式，结构如：
								{
									normal = {
										label = {font = "MicrosoftYaHei", size=19, color="#FFFFFF"}, 
										skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultNormal"), isRevers = true}, 
}, 
									selected = {
										label = {color = "#00FF00"}, 
										skin = {scale9Rect = {left = 25, right = 25, top = 10, bottom = 10}}
}, 
									disabled = {
										label = {color = "#999999"}, 
										--默认状态下scale9Rect的四个值都是0，left：左边距，right：右边距，top：上边距，bottom：下边距
										skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultDisabled"), scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
}
}

@return	返回ccui.Button对象

@example
	function onClick(target, event)
		print("Clicked:", target, event)
	end

	local btn = newButton({
		text = "FullStyle", 
		style = {
			normal = {
				label = {
					font = "MicrosoftYaHei", 
					size = 24, 
					color = "#FFFFFF", 
}, 
				skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultNormal")}
}, 
			selected = {
				label = {color = "#FFFFFF"}, 
				skin = {scale9Rect = {left = 25, right = 25, top = 10, bottom = 10}}
}, 
			disabled = {
				label = {color = "#999999"}, 
				skin = {src = ResManager.getComponentRes(ComponentTypes.BUTTON, "defaultDisabled"), scale9Rect = {left = 10, right = 10, top = 10, bottom = 10}}
}
}, 
		width = 100, 
		height = 50, 
		onClick = onClick
})
]]


function newButton(params)
	params = params or {}

	-- 不用写这么多 style = {normal = {skin = {} } }
	if params.src then
		params.style = {
			normal = {
				skin = {
					src = params.src,
					scale9Rect = params.scale9Rect,
				},
			},
			selected = {
				skin = {
					src = params.src,
					scale9Rect = params.scale9Rect,
				},
			},
			disabled = {
				skin = {
					src = params.src,
					scale9Rect = params.scale9Rect,
				},
			}
		}
	end

	local default_flag = false
	local default_style = nil
	if params.yellowStyle then
		default_style = yellowStyle
		default_flag = true
	elseif params.blueStyle then
		default_style = blueStyle
		default_flag = true
	elseif params.bigYellowStyle then
		default_style = bigYellowStyle
		default_flag = true
	elseif params.bigBlueStyle then
		default_style = bigBlueStyle
		default_flag = true
	elseif params.biggestYellowStyle then
		default_style = biggestYellowStyle
		default_flag = true
	elseif params.biggestBlueStyle then
		default_style = biggestBlueStyle
		default_flag = true
	elseif params.yellowExStyle then
		default_style = yellowExStyle
		default_flag = true
	elseif params.blueExStyle then
		default_style = blueExStyle
		default_flag = true
	elseif params.blueFlowerStyle then
		default_style = blueFlowerStyle
		default_flag = true
	elseif params.yellowFlowerStyle then
		default_style = yellowFlowerStyle
		default_flag = true
	elseif params.greenFlowerStyle then
		default_style = greenFlowerStyle
		default_flag = true
	elseif params.flowerStyle then
		default_style = flowerStyle
		default_flag = true
	elseif params.activityStyle then
		default_style = activityStyle
		default_flag = true
	elseif params.activitySmallStyle then
		default_style = activitySmallStyle
		default_flag = true
	elseif params.activityBigStyle then
		default_style = activityBigStyle
		default_flag = true
	end

	if default_style == nil and params.style == nil then
		-- 默认用yellowStyle
		-- params.style = yellowStyle
		default_style = yellowStyle
	end

	local finalParams = clone(BUTTON_DEFAULT_PARAMS)
	if default_style then
		finalParams.style = clone(default_style)
	end

	local playSound = "ui_click"
	if params.playSound ~= nil then
		playSound = params.playSound
	end

	THSTG.TableUtil.mergeA2B(params, finalParams)

	if default_flag == false and params.style then
		local paramsStyleNormal = params.style.normal
		if paramsStyleNormal then
			if paramsStyleNormal.label then
				--如果有传入普通状态下的文本样式而没有传选中和不可用状态文本样式，则选中和不可用状态也用普通状态文本样式
				if not params.style.selected or not params.style.selected.label then
					finalParams.style.selected.label = clone(finalParams.style.normal.label)
				end

				if not params.style.disabled or not params.style.disabled.label then
					finalParams.style.disabled.label = clone(finalParams.style.normal.label)
				end
			end

			if paramsStyleNormal.skin then
				if not paramsStyleNormal.skin.scale9Rect then
					finalParams.style.normal.skin.scale9Rect = false --{left=0, right=0, top=0, bottom=0}
				end

				--如果有传入普通状态下的皮肤样式而没有传选中和不可用状态皮肤，则选中和不可用状态也用普通状态皮肤
				if not params.style.selected or not params.style.selected.skin then
					finalParams.style.selected.skin = clone(finalParams.style.normal.skin)
				end

				-- if not params.style.disabled or not params.style.disabled.skin then
				-- finalParams.style.disabled.skin = clone(finalParams.style.normal.skin)
				-- end
			end
		end
	end

	local styleNormal = finalParams.style.normal
	local styleSelected = finalParams.style.selected
	local styleDisabled = finalParams.style.disabled
	local redDot = false
	local redOffsetPos = {x = 0, y = 0}

	local btn = ccui.Button:create(styleNormal.skin.src, styleSelected.skin.src, styleDisabled.skin.src)
	btn:ignoreContentAdaptWithSize(false)



	local function updateContentSize()
		local label = btn:getTitleRenderer()
		if label then
			local labelSize = label:getContentSize()
			local btnSize = btn:getContentSize()
			if labelSize.width >= btnSize.width then
				btnSize.width = labelSize.width + (2 * (params.paddingX or 10))
			end
			if labelSize.height >= btnSize.height then
				btnSize.height = labelSize.height + (2 * (params.paddingY or 10))
			end
			btn:setContentSize(btnSize)
		end
		setHitFactor(btn, params.hitLen)
		if(redDot)then
			local labelSize = label:getContentSize()
			local btnSize = btn:getContentSize()
			redDot:setPosition(cc.p(
				labelSize.width / 2 + btnSize.width / 2 + redOffsetPos.x,
				labelSize.height / 2 + btnSize.height / 2 + redOffsetPos.y))
		end
	end

	--更新文本样式
	local function updateTextStyle(textStyle)
		local color = textStyle.color
		btn:setTitleColor(cc.c3b(color.r, color.g, color.b))
		btn:setTitleFontSize(textStyle.size)
		btn:setTitleFontName(textStyle.font)

		local label = btn:getTitleRenderer()
		label:updateCommomStyle(textStyle)

		updateContentSize()
	end

	local __setEnabled = btn.setEnabled
	function btn:setEnabled(value)
		if btn:isEnabled() ~= value then
			__setEnabled(self, value)
			self:setBright(value)

			local textStyle = value and styleNormal.label or styleDisabled.label
			updateTextStyle(textStyle)
		end
	end

	local __setSelected = btn.__setSelected
	function btn:setSelected(value)
		if btn:isEnabled() ~= value then
			__setEnabled(self, value)
			self:setBright(value)
			local textStyle = value and styleNormal.label or styleSelected.label
			updateTextStyle(textStyle)
		end
	end

	function btn:getText() return self:getTitleText() end
	function btn:setText(value)
		finalParams.text = value
		self:setTitleText(value)
		updateContentSize()
	end

	function btn:setString(value)
		btn:setText(value)
	end
	function btn:getString()
		return btn:getText()
	end


	-- 添加一个点击函数
	function btn:onClick(func)
		params.onClick = func
	end

	function btn:updateSkinStyle(style)

		local tmpParams = clone(BUTTON_DEFAULT_PARAMS)
		THSTG.TableUtil.mergeA2B(style, tmpParams.style)

		local skin = tmpParams.style.normal.skin

		btn:loadTextureNormal(skin.src)
		btn:loadTexturePressed(skin.src)
		local normalCapInsets = skin2CapInsets(skin)
		if normalCapInsets then
			btn:setCapInsets(normalCapInsets)
			btn:setScale9Enabled(true)
			btn:setCapInsetsPressedRenderer(normalCapInsets)
		end

		local skinSize = skin2OrgSize(skin)
		btn:setContentSize(skinSize)
		updateContentSize()
	end

	function btn:updatePreSize(style)
		btn:setContentSize(cc.size(finalParams.width, finalParams.height))
		updateContentSize()
	end

	function btn:updateTextStyle(style)
		local label = btn:getTitleRenderer()
		label:updateCommomStyle(style)

		updateContentSize()
	end

	local buttonEffectNode
	

	btn:setTouchEnabled(true)
	if params.isTouchAction ~= nil then
		btn:setPressedActionEnabled(params.isTouchAction)
	else
		btn:setPressedActionEnabled(true)
	end
	btn:setAnchorPoint(finalParams.anchorPoint)
	btn:setPosition(finalParams.x, finalParams.y)

	local normalCapInsets = THSTG.UI.skin2CapInsets(styleNormal.skin)
	if normalCapInsets then
		btn:setCapInsets(normalCapInsets)
		btn:setScale9Enabled(true)
	end

	local pressedCapInsets = THSTG.UI.skin2CapInsets(styleSelected.skin)
	if pressedCapInsets then
		btn:setCapInsetsPressedRenderer(pressedCapInsets)
	end

	local disabledCapInsets = THSTG.UI.skin2CapInsets(styleDisabled.skin)
	if disabledCapInsets then
		btn:setCapInsetsDisabledRenderer(disabledCapInsets)
	end

	if finalParams.width > 0 or finalParams.height > 0 then
		local texSize = btn:getVirtualRendererSize()
		if finalParams.width <= 0 then
			finalParams.width = texSize.width
		end
		if finalParams.height <= 0 then
			finalParams.height = texSize.height
		end
		btn:setContentSize(cc.size(finalParams.width, finalParams.height))
	end

	if finalParams.text ~= "" then
		btn:setTitleText(finalParams.text)
	end

	updateTextStyle(styleNormal.label)

	if type(finalParams.zoomScale) == "number" then
		btn:setZoomScale(finalParams.zoomScale)
	end

	local function onTouch(sender, eventType)
		local event = {x = 0, y = 0}
		event.target = sender

		if eventType == ccui.TouchEventType.began then
			updateTextStyle(styleSelected.label)
			event.name = "began"
		elseif eventType == ccui.TouchEventType.moved then
			event.name = "moved"
		elseif eventType == ccui.TouchEventType.ended then
			if sender:isEnabled() then
				updateTextStyle(styleNormal.label)
			else
				updateTextStyle(styleDisabled.label)
			end
			event.name = "ended"


			if type(playSound) == "string" then
				--TODO:点击音效
				--SoundManager.playSound(playSound)
			end

			if type(params.onClick) == "function" then
				params.onClick(sender, "click")
				printStack(params.onClick)
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if sender:isEnabled() then
				updateTextStyle(styleNormal.label)
			else
				updateTextStyle(styleDisabled.label)
			end
			event.name = "cancelled"
		end

		if type(params.onTouch) == "function" then
			params.onTouch(event, sender)
		end
	end
	btn:addTouchEventListener(onTouch)
	btn:setEnabled(finalParams.enabled)

	btn:setTouchEnabled(true)

	if params.redDotData then
		btn:addRedDot(params)
	end

	if params.yellowFlowerStyle or params.greenFlowerStyle then
		local label = btn:getTitleRenderer()
		label:setOpacity(255 * 0.5)
	end


	THSTG.UI.setHitFactor(btn, params.hitLen)

	return btn
end
