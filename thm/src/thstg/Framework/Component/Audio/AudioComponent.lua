module("AUDIO", package.seeall)
local INVALID_AUDIO_ID = -1

local AudioEngine = ccexp.AudioEngine
local FileUtils = cc.FileUtils:getInstance()

--新建一个音效组件
--@param    #volume        number             音量
--@param    #src          string              文件路径
--@param    #isLoop       bollean             是否无限循环

local function commonInit(node,params)
    node._privateData = {}
    _privateData.id = INVALID_AUDIO_ID
    _privateData.src = params.src or ""
    _privateData.isLoop = params.isLoop
    _privateData.src = params.src
    _privateData.isSilence = params.isSilence or false
    _privateData.volume = _privateData.isSilence and 0 or (params.volume or 50)
    _privateData.onEnd = params.onEnd
    
    ----
    function node:play()

        local isLoop = _privateData.isLoop or true
        local volume = _privateData.volume
        local isSilence = _privateData.isSilence

        local exist, filePath = FileUtils:isFileExist(_privateData.src),_privateData.src
        if not exist then
            print("Error! The file [" .. filePath .. "] is not exist!")
            return false
        end

        if params.onLoad and "function" == type(params.onLoad) then
            AudioEngine:preload(filePath, function(isloadSuccess)
                params.onLoad(node,isloadSuccess)
            end)
        end
    
        _privateData.id = AudioEngine:play2d(filePath, isLoop, volume / 100)
        if _privateData.id == INVALID_AUDIO_ID then return false end

        local function onPlayEnd(id, path)
            if type(_privateData.onEnd) == "function" then
                _privateData.onEnd(node)
            end 
        end
        AudioEngine:setFinishCallback(_privateData.id, onPlayEnd)
      
        return true
    end
    ----
    function node:getID()
        return _privateData.id
    end
    
    function node:stop()
        if _privateData.id == INVALID_AUDIO_ID then return end
        AudioEngine:stop(_privateData.id)
        _privateData.id = INVALID_AUDIO_ID
    end

    function node:pause()
        if _privateData.id == INVALID_AUDIO_ID then return end
        AudioEngine:pause(_privateData.id)
    end

    function node:resume()
        if _privateData.id == INVALID_AUDIO_ID then return end
        AudioEngine:resume(_privateData.id)
    end

    function node:getVolume()
        return _privateData.volume
    end

    function node:setVolume(volume)
        volume = math.min(volume,100)
        volume = math.max(volume,0)
        _privateData.isSilence = (volume <= 0)
        _privateData.volume = volume
        if _privateData.id ~= INVALID_AUDIO_ID then
            AudioEngine:setVolume(_privateData.id, volume / 100)
        end
    end

    function node:isSilence()
        return _privateData.isSilence
    end

    function node:setSilence(val)
        if val then self:setVolume(0)
        else
            self:setVolume(_privateData.volume) 
        end
    end

    return node._privateData
end


--@param    #onEnd        function            结束回调
function newSound(params)
    local node = cc.Node:create()
    local _privateData = commonInit(node,params)

    function node:play()
        return self.super.play()
    end


    return node
end

--@param    #onLoad        function             加载回调
--@param    #onEnd        function            结束回调
function newMusic(params)
    local node = cc.Node:create()
    local _privateData = commonInit(node,params)
    ------
    function node:play()
        if _privateData.id ~= INVALID_AUDIO_ID then 
            self:stop() 
            AudioEngine:uncache(_privateData.src)
        end
        return self.super.play(self)
    end

    -------------------------
    
    --得到音乐总时间长度
    function node:getDuration()
        if _privateData.id ~= INVALID_AUDIO_ID then
            return AudioEngine:getDuration(_privateData.id)
        end

        return 0
    end

    --得到音乐当前播放时间
    function node:getCurrentTime()
        if _privateData.id ~= INVALID_AUDIO_ID then
            return AudioEngine:getCurrentTime(_privateData.id)
        end

        return 0
    end

    --设置音乐当前播放时间 返回成功与否
    function node:setCurrentTime(curTime)
        --无效判断
        if _privateData.id == INVALID_AUDIO_ID then
            return false
        end
        --音乐长度
        local timeLength = AudioEngine:getDuration(_privateData.id)
        
        if timeLength <= 0 then
            return false
        end
        --处理参数
        curTime = (not curTime) and 0 or curTime
        curTime = (curTime < 0) and 0 or curTime
        curTime = (curTime > timeLength) and timeLength or curTime

        --设置时间
        AudioEngine:setCurrentTime(_privateData.id, curTime)

        return true
    end
    
    return node
end