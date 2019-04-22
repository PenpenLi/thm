--预加载列表
return {
    --全局欲加载
    preLoadGlobal = function (callback)
        --动画预加载
        THSTG.AnimationService.preloadDBXFile(
            ResManager.getResSub(ResType.ANIMATION,AnimationType.SEQUENCE,"player00_tex"),
            ResManager.getResSub(ResType.ANIMATION,AnimationType.SEQUENCE,"player00_ske"))

    end,

}