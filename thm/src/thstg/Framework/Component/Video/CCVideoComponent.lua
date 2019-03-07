-- module("Video", package.seeall)

-- 新建视频播放
-- @param	x			[number]		x
-- @param	y			[number]		y
-- @param   width		[number]		宽
-- @param   height		[number]		高
-- @param	isFullScene	[boolean]		是否全屏
-- @param	src			[string]		文件路径
-- @param	isLoop		[boolean]		是否循环

-- @param 	onComplete	[function]		播放完成回调

function newVideoPlayer(params)
    params = params or {}
    ---
    local node = ccexp.VideoPlayer:create() --创建
    if params.src then
        node:setFileName(src)    --资源文件位置
    end

    if params.anchorPoint then
        node:setAnchorPoint(params.anchorPoint)
    end
    node:setPosition(cc.p(params.x or display.cx,params.y or display.cy))

    if params.isFullScene then
        node:setFullScreenEnabled(params.isFullScene)
    else
        if params.width and params.height then
            node:setContentSize(cc.size(params.width, params.height))
        end
    end
    if params.isLoop then 
        params.onComplete = function(sender)
            sender:play()
        end
    end
    if type(params.onComplete) == "function" then
        node:addEventListener(function(sener, eventType)
            if eventType == ccexp.VideoPlayerEvent.COMPLETED then
                params.onComplete(sener)
            end
        end)
    end	
    
    return node
end