module(..., package.seeall)

local M = {}
function M.create(params)
    -------Model-------

    local _uiIcon1 = nil
    local _uiWordCn = nil
    local _uiWordEn = nil
    -------View-------
    local node = THSTG.UI.newNode()

    --加载动画
    _uiIcon1 = THSTG.UI.newImage({
        x = 470,
        y = 40,
        anchorPoint= THSTG.UI.POINT_CENTER,
        source = ResManager.getResSub(ResType.UI,ModuleType.LOADING,"loading_icon_1")
    })
    node:addChild(_uiIcon1)

    _uiWordCn = THSTG.UI.newImage({
        x = 500,
        y = 45,
        anchorPoint= THSTG.UI.POINT_CENTER,
        source = ResManager.getResSub(ResType.UI,ModuleType.LOADING,"loading_word_cn")
    })
    node:addChild(_uiWordCn)

    _uiWordEn = THSTG.UI.newImage({
        x = 560,
        y = 25,
        anchorPoint= THSTG.UI.POINT_CENTER,
        source = ResManager.getResSub(ResType.UI,ModuleType.LOADING,"loading_word_en")
    })
    node:addChild(_uiWordEn)


    -------Controller-------
    function node.updateLayer()
        _uiIcon1:runAction(cc.RepeatForever:create(
            cc.RotateBy:create(1,290)
        ))
        local fadeAction1 = cc.RepeatForever:create(cc.Sequence:create({
            cc.FadeIn:create(1),
            cc.FadeOut:create(1),
        }))

        local fadeAction2 = cc.RepeatForever:create(cc.Sequence:create({
            cc.FadeIn:create(1),
            cc.FadeOut:create(1),
        }))

        _uiWordCn:runAction(fadeAction1)
        _uiWordEn:runAction(fadeAction2)
    end

    node:onNodeEvent("enter", function ()
        node.updateLayer()
    end)

    node:onNodeEvent("exit", function ()
        
    end)

    return node
end

return M