-- module("ANIMATION", package.seeall)


-- 新建动画精灵
-- @param	x			[number]		x
-- @param	y			[number]		y
-- @param   width		[number]		宽
-- @param   height		[number]		高
-- @param	animation	[userdata]		动画
-- @param 	onStart		[function]		动画开始回调
-- @param 	onComplete		[function]	动画完成回调
-- @param 	onEnd		[function]		动画结束回调

function newAnimationSprite(params)
    params = params or {}
    ---
    local privateData = {}
    privateData.onStart = params.onStart
    privateData.onComplete = params.onComplete
    privateData.onEnd = params.onEnd

    privateData.isLoop = params.isLoop or false
    privateData.isReversed = params.isReversed or false
    privateData.animation = params.animation

    local node = newSprite(params)

    ----

    function node:playAnimation(animation,isLoop,isReversed)
        if not animation then return end

        local actions = {}
        local animateAction = false
        
        local animate = (isReversed and {cc.Animate:create(animation):reverse()} or {cc.Animate:create(animation)})[1]
        
        if type(privateData.onComplete) == "function" then
            animateAction = cc.Sequence:create({
                animate,
                cc.CallFunc:create(handler(node,privateData.onComplete))
            })
        else
            animateAction = animate
        end

        if type(privateData.onStart) == "function" then table.insert(actions,cc.CallFunc:create(handler(node,privateData.onStart))) end
        if isLoop then 
            table.insert(actions,cc.CallFunc:create(function()
                self:runAction(cc.RepeatForever:create(animateAction))
            end))
        else 
            table.insert(actions,animateAction) 
        end
        if type(privateData.onEnd) == "function" then table.insert(actions,cc.CallFunc:create(handler(node,privateData.onEnd))) end
        
        local action = cc.Sequence:create(actions)
        self:runAction(action)

        return actions
    end

    function node:stopAnimation()
        self:stopAllActions()
    end
    ---
    if privateData.animation then
        node:playAnimation(privateData.animation,privateData.isLoop,params.isReversed)
    end

    return node
end