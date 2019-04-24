--预加载列表
return {
    --全局欲加载
    _Global = function (callback)
        --动画预加载
        THSTG.AnimationSystem.preloadDBXFile(
            ResManager.getResSub(ResType.TEXTURE,TexType.SHEET,"player00"),
            ResManager.getResSub(ResType.ANIMATION,AnimType.SEQUENCE,"player00_ske"))

    end,

}