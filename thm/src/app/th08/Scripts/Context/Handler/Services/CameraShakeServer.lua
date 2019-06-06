--震屏相关---------------------
---震动地面----------------------------
--@param	#number		time 		总时间(s)
--@param	#number		ratio 		震动系数值越大震幅越大
--@param	#number		easeFunc 	缓动函数
local M = {}
local isShaking = false
local function __formatAvailableY(y)
	local visibleSize = cc.Director:getInstance():getVisibleSize()
	local resultY = y
	local cRect = cc.rect(0,0,visibleSize.width,visibleSize.height)
	local minMapY = display.height - visibleSize.height
	local finalGlobalY = -cRect.y + y
	if finalGlobalY > 0 then
		resultY = -cRect.y
	elseif finalGlobalY < minMapY then
		resultY = -cRect.y - minMapY
	end
	return resultY
end

function M.runShake(node, time, ratio, easeFunc)
	if isShaking then return end

	time = time or 0.1
	ratio = ratio or 1.1

	local orgX, orgY = node:getPosition()

	local y1 = __formatAvailableY(orgY - 45 * ratio)
	local y2 = __formatAvailableY(orgY + 45 * ratio)
	local y3 = __formatAvailableY(orgY - 30 * ratio)
	local y4 = __formatAvailableY(orgY + 15 * ratio)
	local y5 = __formatAvailableY(orgY - 15 * ratio)

	local timeline = {}
	for k = 1, math.floor(time / 0.1)-1 do
		timeline[#timeline + 1] = cc.MoveTo:create(0.05, cc.p(orgX, y1))
		timeline[#timeline + 1] = cc.MoveTo:create(0.05, cc.p(orgX, y2))
	end
	timeline[#timeline + 1] = cc.MoveTo:create(0.04, cc.p(orgX, y3))
	timeline[#timeline + 1] = cc.MoveTo:create(0.03, cc.p(orgX, y4))
	timeline[#timeline + 1] = cc.MoveTo:create(0.03, cc.p(orgX, y5))

	local function onComplete()
		node:setPosition(orgX, orgY)
		isShaking = false
	end
	local endCallback = cc.CallFunc:create(onComplete)
	table.insert(timeline, endCallback)

	local shakeAction = cc.Sequence:create(timeline)
	if easeFunc then
		shakeAction = easeFunc:create(shakeAction)
	end

	node:runAction(shakeAction)
end

--停止震动
function M.stopShake(node)
	if not isShaking then return end
	isShaking = false
	node:stopAllActions()
end

return M