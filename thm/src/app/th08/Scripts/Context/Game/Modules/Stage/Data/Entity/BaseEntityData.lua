local M = class("BaseEntityData")
local EEntityType = GameDef.Stage.EEntityType

function M:ctor(params)
    self._data = {}
    self._code = 0

    self:_initData(params)
end

function M:getData()
    return self._data
end

--由于有模板的存在,主id都不一定准确,因此保留一个传入Code
function M:getCode()
    return self._code
end

function M:getConfigData()
    return self._data.cfgData
end

function M:getAnimationData()
    return self._data.animaData
end

function M:_initData(params)
    params = params or {}

    local code = params.code or params.cfgCode
    local cfgCode = params.cfgCode or code
    local animaCode = params.animaCode or code

    self._code = code

    --这里加缓存,防止重复查找
    local data = EntityDataCache.get(code)
    if data then 
        self._data = data 
        return 
    else
        --如果第一次没有找到,则往上找模板,直到完全找不到为止
        local function tryGetInfo(code,func)
            local curCode = code
            local infoTb = nil
            local count = 1
            while(infoTb == nil and curCode > 0) do
                infoTb = func(curCode)
                if infoTb == nil then
                    local bitNum = math.floor(math.pow(10,count))
                    curCode = math.floor((curCode / bitNum)) * bitNum
                    count = count + 1
                end
            end
            return infoTb
        end

        local animData = false
        local cfgData = false

        --动画信息
        animData = tryGetInfo(animaCode,function(code) return AnimationConfig.getAllInfo(code) end)

        --主配信息
        local type = EntityUtil.code2Type(code)
        if type == EEntityType.Player then
            cfgData = tryGetInfo(cfgCode,function(code) return PlayerConfig.getAllInfo(code) end)
        elseif type == EEntityType.Wingman then
            cfgData = tryGetInfo(cfgCode,function(code) return WingmanConfig.getAllInfo(code) end)
        elseif type == EEntityType.Boss then
            cfgData = tryGetInfo(cfgCode,function(code) return BossConfig.getAllInfo(code) end)
        elseif type == EEntityType.Batman then
            cfgData = tryGetInfo(cfgCode,function(code) return BatmanConfig.getAllInfo(code) end)
        elseif type == EEntityType.PlayerBullet then
            cfgData = tryGetInfo(cfgCode,function(code) return PlayerBulletConfig.getAllInfo(code) end)
        elseif type == EEntityType.EnemyBullet then
            cfgData = tryGetInfo(cfgCode,function(code) return EnemyBulletConfig.getAllInfo(code) end)
        elseif type == EEntityType.WingmanBullet then
            cfgData = {}
        elseif type == EEntityType.Prop then
            cfgData = tryGetInfo(cfgCode,function(code) return PropConfig.getAllInfo(code) end)
        end

        assert(cfgData,string.format("Can't not find the cfgData:%s",code))
        assert(animData,string.format("Can't not find the animData:%s",code))

        self._data.cfgData = cfgData
        self._data.animaData = animData

        EntityDataCache.add(code, self._data)
    end
end

return M