module(..., package.seeall)

function getDiffSelInfos()
    local hideDiff = SelectionConfig.getDiffHideCnt()
    local infos = SelectionConfig.getDiffInfos()
    local ret = {}
    for i,v in ipairs(infos) do
        if i <= hideDiff then
            table.insert( ret, v )
        end
    end
    return ret
end

----
function clear()
    
end