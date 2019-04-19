DBXAtlas = require "thstg.Framework.Component.Animation.DBX.DBXAtlas"
DBXSkeleton = require "thstg.Framework.Component.Animation.DBX.DBXSkeleton"
DBXAnimater = require "thstg.Framework.Component.Animation.DBX.DBXAnimater"
DBXManager = require "thstg.Framework.Component.Animation.DBX.DBXManager"
------
function newDBXAnimater(params)
    params = params or {}
    local animater = DBXAnimater.new()
    animater:load(params.tex,params.ske)

    return animater
end