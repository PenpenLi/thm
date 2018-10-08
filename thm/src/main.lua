
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
require "thstg.init"

local function main()
    THSTG.EngineEx:create({
        gameRoot = "app.th08",
        gameName = "TH08"
    }):run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
