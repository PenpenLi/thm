

-- 新建Spine动画
-- @param	x			[number]		x
-- @param	y			[number]		y
-- @param   width		[number]		宽
-- @param   height		[number]		高
-- @param	jsonSrc		[string]		骨骼数据文件
-- @param	atlasSrc	[string]		资源集文件
-- @param	src			[string]		文件路径(上面的简写,只需要json文件路径即可)
-- @param	amination	[string]		默认动作
-- @param 	onStart		[function]		动画开始回调
-- @param 	onComplete		[function]	动画完成一次回调
-- @param 	onEnd		[function]		动画结束回调
function newSpineAnimation(params)
    params = params or {}

    if params.src then
        local dir = params.src
        local fileName = FileUtil.stripPath(params.src)
        
        if fileName then 
            dir = string.sub(dir,1,string.find(dir,fileName) - 2)
            fileName = FileUtil.stripExtension(fileName)
            
        else 
            fileName = string.sub(params.src,string.match(params.src, ".*()/")+1)
        end
        params.jsonSrc = string.format("%s/%s.json",dir, fileName)
        params.atlasSrc = string.format("%s/%s.atlas",dir, fileName)
        
    end
    local node = sp.SkeletonAnimation:create(params.jsonSrc,params.atlasSrc)
    if params.anchorPoint then
        node:setAnchorPoint(params.anchorPoint)
    end
    node:setPosition(cc.p(params.x or display.cx,params.y or display.cy))
    if params.amination then
        node:setAnimation(0, params.amination, true)
    end
    if params.width and params.height then
        node:setContentSize(cc.size(params.width, params.height))
    end

    if type(params.onStart) == "function" then node:registerSpineEventHandler(handler(node,params.onStart), sp.EventType.ANIMATION_START) end
    if type(params.onComplete) == "function" then node:registerSpineEventHandler(handler(node,params.onComplete), sp.EventType.ANIMATION_COMPLETE) end
    if type(params.onEnd) == "function" then node:registerSpineEventHandler(handler(node,params.onEnd), sp.EventType.ANIMATION_END) end

    ---
    
    local _isSet = false
    function node:playAnimation(trackIndex,name,isLoop)
        if not _isSet then
            -- self:setToSetupPose()
            local trackEntry = self:setAnimation(trackIndex,name,isLoop)
            -- if (trackEntry) then
            -- 	self:
            -- end

            _isSet = true
        else
            self:clearTracks()
            self:addAnimation(trackIndex,name,isLoop)
        end
    end

    --移除操作必须延迟,包括移除其父节点也是如此
    function node:removeFromParent()
        self:runAction(cc.Sequence:create({
            cc.DelayTime:create(0.01),
            cc.RemoveSelf:create(),
        }))
    end

    return node
end