--FIXME:这里写成ccclass时,onReadyStateChanged()回调有可能被析构,在execute()返回前执行一次延时操作可以减少析构率
--原因不明,待高人指出错误
local HttpFileDownLoad = {}--ccclass("HttpFileDownLoad")
--如果为ccclass,下面的构造函数要去掉
function HttpFileDownLoad.new()
    HttpFileDownLoad:ctor()
    return HttpFileDownLoad
end

--[[构造函数
    url:网络路径
    id:任务id，用于回调时区分任务
--]]

-- local HttpFileDownLoad = ccclass("HttpFileDownLoad")

function HttpFileDownLoad:ctor()
    self:initData()
end

function HttpFileDownLoad:initData()
    self.status = "wait"
    self.path = nil
    
    self:setSaveRoot(nil)
    self:setSaveFolder(nil)
    self:setSaveName(nil)
    
end

function HttpFileDownLoad:sendHttpRequest(url, id , callBackFunc)
    self.url = url
    self.id = id
    self.onCallBackFunc = callBackFunc

    self:execute()
end

function HttpFileDownLoad:setCallBackFunc(callBackFunc)
    self.onCallBackFunc = callBackFunc
end

--设置加载成功后的回调
function HttpFileDownLoad:onSuccess(func)
    self.onSuccessFunc = func
    return self
end

--设置加载失败后的回调
function HttpFileDownLoad:onError(func)
    self.onErrorFunc = func
    return self
end

--设置存储根目录,需在execute之前执行，是否必须调用，可选，否则使用默认名称
function HttpFileDownLoad:setSaveRoot( rootName )
    self.parentFolder = rootName or "res"
end

--设置存储名称,需在execute之前执行，是否必须调用，可选，否则使用默认名称
function HttpFileDownLoad:setSaveName( fileName )
    self.fileName = fileName
end

--设置存储路径，需在execute之前执行，是否必须调用，可选，否则使用默认路径
function HttpFileDownLoad:setSaveFolder( folderName )
    self.path = device.writablePath .. self.parentFolder .. device.directorySeparator .. (folderName or "resource")
    --print(__PRINT_TYPE__," -- > img path : " , self.path)
    --创建默认缓存路径
    local isDirExist = cc.FileUtils:getInstance():isDirectoryExist(self.path)
    if not isDirExist then
        cc.FileUtils:getInstance():createDirectory(self.path)
    end
end

function HttpFileDownLoad:getFileCachePath(mUrl , folderPath)
    local urlTb = self:split_str(string.urldecode(mUrl), '/')
    local fileName = self.fileName or urlTb[#urlTb]
    return folderPath .. device.directorySeparator .. fileName
end

--图片加载任务执行
function HttpFileDownLoad:execute()
    self.status = "process"

    --1.设置文件缓存路径
    if not self.url then return self end
    local filePathName = self:getFileCachePath(self.url , self.path)
    --print(__PRINT_TYPE__," -- > img cache path : " , filePathName)

    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_ARRAY_BUFFER
    xhr:open("GET", self.url)
    
    -- XXX:该函数回调时貌似把self销毁了,不知为何为何
    -- 可能是回调时,对象已经被销毁,但是仍不知道在哪里被销毁的
    local function onReadyStateChanged()
        if type(self) == "userdata" and tolua.isnull(self) then 
            xhr:unregisterScriptHandler()
            return 
        end
        
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            --print(__PRINT_TYPE__," ---> img net load get response : " , xhr.statusText )
            local response   = xhr.response
            
            local strInfo = self:getStrData(response)
            io.writefile(filePathName, strInfo, "w+b")
            self:callback("down load ok" , filePathName)
        else
            --print(__PRINT_TYPE__," --- > error xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)
            self:callbackErr(xhr.readyState, xhr.status)
        end
        xhr:unregisterScriptHandler()
    end

    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()

    if type(self) == "userdata" then for i=1,99999999 do end end

    --print(__PRINT_TYPE__," -- > get net watting ... ")
    return self
end

--数据拆分，以没1024*5字节拆成一段，打包写入文件
function HttpFileDownLoad:getStrData(response)
    local totalSize = table.getn(response)
    local onePart = 1024*5
    local partData = ""
    local packTimes = math.floor(totalSize/onePart)

    --print(__PRINT_TYPE__," -- > pack size , times : " , totalSize , packTimes)
    for i=1,packTimes do
        local partUnPack = string.char(unpack(response,1+(i-1)*onePart , i*onePart) )
        partData = partData..partUnPack
        --print(__PRINT_TYPE__," -- > pack new part : " , 1+(i-1)*onePart , i*onePart)
    end
    --print(__PRINT_TYPE__," -- > pack end part : " , packTimes*onePart+1 , totalSize)
    local endUnpack = string.char(unpack(response , packTimes*onePart+1 , totalSize) )
    partData = partData..endUnpack
    return partData
end

--加载成功后的回调
function HttpFileDownLoad:callback(tex , filePathName)
    self.tex = tex
    self.status = "success"
    if self.onSuccessFunc then
        self.onSuccessFunc(tex, self.id)
    end
    if self.onCallBackFunc then
        self.onCallBackFunc(self.status , tex, filePathName , self.id)
    end
end

--加载失败后的回调
function HttpFileDownLoad:callbackErr(errCode, msg)    
    self.errCode = errCode
    self.msg = msg
    self.status = "error"
    if self.onErrorFunc then
        self.onErrorFunc(errCode, msg)
    end
    if self.onCallBackFunc then
        self.onCallBackFunc(self.status , errCode, msg)
    end
end

--拆分字符串的工具

function HttpFileDownLoad:split_str(str, delimiter)
    local resultStrsList = {}
    string.gsub(str, '[^' .. delimiter ..']+', function(w) table.insert(resultStrsList, w) end )
    return resultStrsList
end


----
local M = {}
local mInstance = nil
function M:getInstance()
    if mInstance == nil then
        mInstance = HttpFileDownLoad.new()
    end
    return mInstance
end

function M:new()
    return clone(HttpFileDownLoad.new())
end

return M

---------------------------------------代码结束了--------------------------------------------------

-- 调用方法：

-- HttpFileDownLoad:getInstance():sendHttpRequest(yourReqUrl, "tag_name" , handler(self , self.loadFileCallbackFunc))

-- --回调函数

-- function YourLayer:loadFileCallbackFunc( status , desc, filePath , id )
--     local allFileNameTb = {"game_config.csv" , "move_config.csv" , "target_config.csv" }
--     if status == "success" then
--         if id == "tag_name" then
--          --TODO ，download succ

--         end
--     elseif status == "error" then
--         --print(__PRINT_TYPE__," -- > get net fail : " , desc, id)
--     end
-- end
