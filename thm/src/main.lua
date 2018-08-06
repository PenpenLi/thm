
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
require "thstg.init"

local function main()
    THSTG.EngineEx:create({
        gameRoot = "thstg.Game",
        gameName = "THSTG"
    }):run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
