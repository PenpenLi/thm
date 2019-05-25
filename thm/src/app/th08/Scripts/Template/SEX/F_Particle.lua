
return {
    cclp_light_spot_fadeout_01 = function (param)
        local tex,rect = THSTG.SCENE.loadTexture(SheetConfig.getFrame("etama2","light_spot_01"))
        return {
            tex = tex,
            texRect = rect,


        }
    end,
}