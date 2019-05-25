return {
    --全局预加载
    _Global = function ( ... )
        --图片资源预加载
        SpriteServer.loadDBXFile(ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"etama2"))

    end,

    --一面关卡资源加载
    Stage_01 = function (...)

    end,


}