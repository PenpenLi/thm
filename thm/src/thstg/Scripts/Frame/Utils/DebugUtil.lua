module("THSTG.DebugUtil", package.seeall)

local function dump_value_(v)
    if type(v) == "string" then
        v = "\"" .. v .. "\""
    end
    return tostring(v)
end

function dump(printType, value, desciption, nesting)
    --TODO:DEBUG的宏
    -- if __PRINT_TYPE__ > 0 and printType ~= __PRINT_TYPE__ then
    --     return
    -- end

    -- if not __DEBUG__ then
    --     return 
    -- end

    if type(nesting) ~= "number" then nesting = 25 end

    local lookupTable = {}
    local result = {}

    local traceback = string.split(debug.traceback("", 2), "\n")
    result[#result +1 ] = "dump from: " .. string.trim(traceback[3])

    local function dump_(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(dump_value_(desciption)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, dump_value_(desciption), spc, dump_value_(value))
        elseif lookupTable[tostring(value)] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, dump_value_(desciption), spc)
        else
            lookupTable[tostring(value)] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, dump_value_(desciption))
            else
                result[#result +1 ] = string.format("%s%s = {", indent, dump_value_(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}

                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = dump_value_(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end

                    --针对cdl结构做特殊处理，使打印的数据可读性更高
                    if value.__cname ~= nil and 
                        (k == "__keyPrototype" or k == "__keyBase" or k == "__valuePrototype" or k == "__valueBase") then
                        local typeV = type(v)
                        if typeV ~= "table" then
                            values[k] = tostring(v)
                        else
                            values[k] = v.name
                        end
                    else
                        values[k] = v
                    end
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    dump_(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    dump_(value, desciption, "", 1)
    print((table.concat(result, "\n")))
end