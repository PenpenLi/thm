--速度类
module(..., package.seeall)

function new()
	local M = {
		__cname = "Rigidbody",
	}

	--大小
    local _rect = cc.size(0,0,1,1)
    
	function setRect(rect)
		_rect = rect
	end

	function getRect()
		return _rect
	end

	return M
end
