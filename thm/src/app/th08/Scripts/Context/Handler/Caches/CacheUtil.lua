module(..., package.seeall)

--将参数转为Md5
function getNameKey(tags)
    if type(tags) ~= "table" then tags = {tags} end
    local keys = tags
    local keyName = ""
    for _,v in ipairs(keys) do
        keyName = keyName .. v .. "#"
    end
    keyName = THSTG.MD5.string(keyName)

    return keyName
end