--深度拷贝对象，不能copy userdata对象
function deepcopy(orig)
	local copy

	if type(orig) == "table" then
		copy = {}
		for k, v in pairs(orig) do
			copy[deepcopy(k)] = deepcopy(v)
		end
		if getmetatable(orig) then
			setmetatable(copy, deepcopy(getmetatable(orig)))
		end
	else -- number, string, boolean, etc
		copy = orig
	end

	return copy
end

--用于禁止类实例在构造函数执行完之后再创建类变量
local function errorNewIndex(t, k, v)
	error(string.format("Error! class:'%s' no member variable:'%s'", t.__cname, tostring(k)))
end

--定义一个类对象
--@param	#string		className	类名
--@param	#table		super		父类
--@return	#table	类
function class(className, super, isUserData)
	local cls = {}

	cls.ctor = false
	cls.name = className
	cls.init = false

	cls.__cccreator = false
	cls.__cccreatorSelf = false

	local superType = type(super)
	if "table" == superType then
		cls.super = super

		cls.__cccreator = super.__cccreator
		cls.__cccreatorSelf = super.__cccreatorSelf
	end

	--储存类的所有方法
	cls.funcs = {}
	--储存类实例的重要方法和属性
	cls.instanceIndexT = {}

	--该类所生成实例用于索引的元表
	local instanceIndexT = cls.instanceIndexT

	--instance add defualt clone functon
	function instanceIndexT:clone()
		return deepcopy(self)
	end
	--用于访问父级方法
	function instanceIndexT:super(className, method, ...)
		return self.__supers[className][method](self, ...)
	end

	if cls.super then
		-- print(1, "~~~~~~~~~~~~~~~~~", className)
		for k, v in pairs(cls.super.instanceIndexT) do
			-- print(1, "~~~~~~~class~~~~", k, v)
			if k == "__supers" then
				instanceIndexT[k] = deepcopy(v)
			elseif k ~= "clone" and k ~= "super" then
				instanceIndexT[k] = v
			elseif k == "clone" and type(isUserData) == "boolean" and isUserData then
				instanceIndexT[k] = v
			end
		end
		-- print(1, "~~~~~~~~~~~~~~~~~")
	end

	function cls.new(...)
		local instance = {__cname = cls.name}
		local mt = {
			__index = instanceIndexT,
		}
		setmetatable(instance, mt)

		cls.runCtor(instance, ...)
		cls.runInit(instance, ...)
		--限制只能在构造函数执行完之前定义类变量
		mt.__newindex = errorNewIndex

		return instance
	end

	--执行构造函数
	function cls.runCtor(this, ...)
		local function ctor(c, ...)
			--递归调用父类的构造函数
			if c.super then
				ctor(c.super, ...)
			end

			if c.ctor then
				c.ctor(this, ...)
			end
		end
		ctor(cls, ...)
	end
	--执行构造后的初始化函数
	function cls.runInit(this, ...)
		local function init(c, ...)
			--递归调用父类的构造函数
			if c.super then
				init(c.super, ...)
			end

			if c.init then
				c.init(this, ...)
			end
		end
		init(cls, ...)
	end

	--将类方法copy到指定对象上，主要给ccclass用
	function cls.copyFuncs(this)
		for k, v in pairs(instanceIndexT) do
			this[k] = v
		end
	end

	setmetatable(cls, {
		__newindex = function(t, k, v)
			-- print(1, "~~~__newindex~~~", cls.name, t, k, v)
			if "ctor" == k then
				cls.ctor = v
			elseif "init" == k then
				cls.init = v
			elseif "super" == k then
				error("super方法不能被重新定义！")
			elseif "__cccreator" == k then
				cls.__cccreator = v
			elseif "__cccreatorSelf" == k then
				cls.__cccreatorSelf = v
			else
				--将各级父类的该方法copy到本类中
				if rawget(instanceIndexT, k) then
					local super = cls.super
					while super do
						if super.funcs[k] then
							if not instanceIndexT.__supers then
								instanceIndexT.__supers = {}
							end
							if not instanceIndexT.__supers[super.name] then
								instanceIndexT.__supers[super.name] = {}
							end
							instanceIndexT.__supers[super.name][k] = super.funcs[k]
						end
						super = super.super
					end
				end
				rawset(instanceIndexT, k, v)

				cls.funcs[k] = v
			end
		end
	})

	return cls
end

--定义一个继承自cc对象的类
function ccclass(className, super)
	-- print(1, "-------ccclass:", className, super)
	local cls = nil

	local superType = type(super)
	if "table" == superType then
		cls = class(className, super, true)
	else
		cls = class(className, nil, true)
		if "function" == superType then
			cls.__cccreator = super
		end
	end

	if not cls.__cccreator then
		cls.__cccreator = cc.Node.create
		cls.__cccreatorSelf = cc.Node
	end

	--改写掉类的new方法
	function cls.new(...)
		local node
		if superType == "function" then
			node = cls.__cccreator(...)
		else
			node = cls.__cccreator(cls.__cccreatorSelf)
		end
		node.__cname = cls.name

		--将方法和属性copy到节点上去，并执行构造函数
		cls.copyFuncs(node)
		cls.runCtor(node, ...)
		cls.runInit(node, ...)

		return node
	end

	return cls
end



















