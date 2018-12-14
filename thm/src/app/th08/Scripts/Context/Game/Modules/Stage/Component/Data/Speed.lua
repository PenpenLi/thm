--速度类
module(..., package.seeall)

function new()
	local M = {
		__cname = "Speed",
	}

	--大小
	local _length = 0
	--按比例缩放后的速度大小
	local _scaledLength = 0
	--角度
	local _angle = false
	--分解出来的x, y速度
	local _xSpeed, _ySpeed = 0, 0
	--速度大小缩放比例
	local _scale = 1

	local _sinAngle, _cosAngle = 0, 0


	local function update()
		_xSpeed = _cosAngle * _scaledLength
		_ySpeed = _sinAngle * _scaledLength
		-- print(1, "update", _angle, _length, _xSpeed, _ySpeed)
	end

	--x速度
	function M:getSpeedX() return _xSpeed end
	--y速度
	function M:getSpeedY() return _ySpeed end

	--总速度
	function M:getLength() return _scaledLength end
	function M:setLength(value)
		if _length ~= value then
			_length = value
			_scaledLength = _length * _scale
			update()
		end
	end

	function M:getScale() return _scale end
	function M:setScale(value)
		if _scale ~= value then
			_scale = value
			_scaledLength = _length * _scale
			update()
		end
	end

	--速度方向(角度)
	function M:getAngle() return _angle or 0 end
	function M:setAngle(value)
		if _angle ~= value then
			_angle = value
			local radians = math.rad(_angle)
			_cosAngle = math.cos(radians)
			_sinAngle = math.sin(radians)
			update()
		end
	end

	return M
end
