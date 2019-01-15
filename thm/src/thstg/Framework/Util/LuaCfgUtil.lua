
module("LuaCfgUtil", package.seeall)
--[[
lua配置处理类
读写lua格式配置文件

load 读取lua配置文件
save 写入lua配置文件
getConfig 获取当前缓存的配置
--]]

local LuaConfig = {}
-- 各种参数
LuaConfig._config = nil
LuaConfig._defFilePath = cc.FileUtils:getInstance():getWritablePath().."config.lua"
LuaConfig._formatString = ""


-- 设置格式化输出缩进
function setFormatString(formatString)
    LuaConfig._formatString = formatString
end

-- 序列化 准备存储 返回序列化后的字符串 缩进暂时为1空格 参数为nil时 处理_config
function serialize(config, formatString)
    if config == nil then -- nil不处理
        return "nil"
    end

    local serializedConfig = ""
    local formatString = formatString or LuaConfig._formatString
    local tableFormatString = string.gsub(formatString, LuaConfig._formatString, "", 1) -- table去掉一个缩进

    -- 序列化操作 number boolean string table  
    local paramType = type(config)
    if paramType == "number" then
        serializedConfig = serializedConfig..tostring(config)
    elseif paramType == "boolean" then
        serializedConfig = serializedConfig..tostring(config)
    elseif paramType == "string" then
        serializedConfig = serializedConfig..string.format("%q", config) -- 接受一个字符串并将其转化为可安全被Lua编译器读入的格式 主要防止使用if或其他关键字之类的作为key的情况
    elseif paramType == "table" then
        serializedConfig = serializedConfig.."\n"
        serializedConfig = serializedConfig..tableFormatString.."{\n"
        for k,v in pairs(config) do
            serializedConfig = serializedConfig..formatString
            serializedConfig = serializedConfig.."["..LuaCfgUtil.serialize(k).."]"
            serializedConfig = serializedConfig.." = "
            serializedConfig = serializedConfig..LuaCfgUtil.serialize(v, formatString..LuaConfig._formatString)
            serializedConfig = serializedConfig..",\n"
        end
        serializedConfig = serializedConfig..tableFormatString.."}"
    else
        print("can not handle this type:"..paramType)
    end

    return serializedConfig
end

-- 获取当前配置
function getConfig()
    return LuaConfig._config
end

-- 读取配置 同时返回读取到的配置 方便外部操作
function load(path)
    if path == nil then
        path = LuaConfig._defFilePath
    end

    local content = LuaCfgUtil.readFromFile(path)
    if content ~= nil then
        LuaConfig._config = loadstring("return "..content)() -- loadstring载入后默认为function类型，需要加()以调用
    end

    return LuaConfig._config
end

-- 保存配置 参数为nil时 处理_config
function save(path, config)
    -- 默认处理_config
    if config == nil then
        config = LuaConfig._config
    end
    if path == nil then
        path = LuaConfig._defFilePath
    end

    local isSuccess = false
    -- 设置缩进
    LuaCfgUtil.setFormatString("  ")
    -- 序列化
    local serializedConfig = LuaCfgUtil.serialize(config)
    if serializedConfig ~= nil then
        -- 存储到文件
        isSuccess = LuaCfgUtil.saveToFile(serializedConfig, path)
    end

    return isSuccess
end

-- 存储
function saveToFile(content, path)
    local isSuccess = false
    local file = io.open(path, "w")
    if file ~= nil then
        file:wirte(content)
        file:flush()
        isSuccess = true
    end
    io.close() -- 同file:close() 参数可传file，或默认关闭当前打开的

    return isSuccess
end

-- 读取
function readFromFile(path)
    local content = nil

    --[[ 调用lua本身接口 可能有文件大小限制 据说是最大9K 未验证
    local file = io.open(path, "r")
    if file ~= nil then
        content = file:read("*a") -- 读取所有内容
    end
    io.close() -- 同file:close() 参数可传file，或默认关闭当前打开的
    --]]
    ---[[ 调用cocos相关接口
    content = cc.FileUtils:getInstance():getStringFromFile(path)
    --]]
    return content
end

