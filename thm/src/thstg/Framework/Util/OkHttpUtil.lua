module("OkHttpUtil", package.seeall)

local mInstance = nil

function getInstance()
    if mInstance == nil then
        mInstance = HttpFileDownLoad:new()
    end
    return mInstance
end

