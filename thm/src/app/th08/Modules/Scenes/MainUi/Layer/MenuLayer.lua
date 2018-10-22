module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
    local DELAY_TIME = 8
    local _uiTitleList = nil 
    local _uiDescText = nil 

    local _timerCheckMove = nil

    local _varIsCanMove = true
    local _varLstTime = 0
    local _selectedChangedHandle = nil
    --------View--------
    local node = THSTG.UI.newNode()

    local function createTemplate()
        local node = THSTG.UI.newWidget({
            width = 200,
            height = 25,
        })

        local title = THSTG.UI.newBMFontLabel({
            x = node:getContentSize().width/2,
            y = node:getContentSize().height/2,
            anchorPoint = THSTG.UI.POINT_CENTER,
            style = {
                font = ResManager.getResSub(ResType.FONT, FontType.FNT, "menu_font_black"),
            },
            
        })
        node:addChild(title)

        --
        function node:setState(data, pos)

            title:setText(data.title)
            local newPos = cc.p(title:getPositionX()  + data.offsetPos.x ,title:getPositionY()  + data.offsetPos.y )
            title:setPosition(newPos)

            local nextMoveBy = data.moveBy
            title:stopAllActions()
            -- title:runAction(cc.Sequence:create({
                -- cc.DelayTime:create(2.0),	--预备时间
                -- cc.CallFunc:create(function()
                    title:runAction(cc.RepeatForever:create(cc.Sequence:create({
                        cc.DelayTime:create(DELAY_TIME),
                        cc.CallFunc:create(function ()
                            if _varIsCanMove then
                                title:runAction(cc.MoveBy:create(2, nextMoveBy))
                                nextMoveBy = cc.p(-nextMoveBy.x,-nextMoveBy.y)
                            end
                        end),
                    })))
                -- end),
            -- }))

                    

            --
            --只是选中,并非进入
            if data.__isClick == true then
                title:setFntFile(ResManager.getResSub(ResType.FONT, FontType.FNT, "menu_font_white"))
            else
                title:setFntFile(ResManager.getResSub(ResType.FONT, FontType.FNT, "menu_font_black"))
            end
        end
        function node:_onCellClick(data)
            if data.value.__isClick == true then
                title:setFntFile(ResManager.getResSub(ResType.FONT, FontType.FNT, "menu_font_white"))
            else
                title:setFntFile(ResManager.getResSub(ResType.FONT, FontType.FNT, "menu_font_black"))
            end
        end

        return node
    end
    --

    --  大背景
    --  local mainBg = THSTG.UI.newImage({
    --     x = display.cx,
    --     y = display.cy,
    --     anchorPoint = THSTG.UI.POINT_CENTER,
    --     src = ResManager.getUIRes(UIType.MAIN_SCENE, "") --TODO:

    -- })
    -- node:addChild(mainBg)

    _uiTitleList = THSTG.UI.newTileList({
        x = 138,
        y = 286,
        width = 350, 
        height = 280, 
        anchorPoint = THSTG.UI.POINT_CENTER_TOP,
        colCount = 1,
        itemColGap = 5,
        bounceEnabled = false,

        isOnChange = true,
        -- padding = {left= 0,right=0,top=0,bottom =5},
        direction = ccui.ListViewDirection.vertical,
        itemTemplate = createTemplate,
        onSelectedIndexChange = function (sender,node, index, value, lastIndex, lastValue)
            return _selectedChangedHandle(sender,node, index, value, lastIndex, lastValue)
        end,
    })
    node:addChild(_uiTitleList)


    _uiDescText = THSTG.UI.newRichText({
		x = 200,
		y = 20,
        anchorPoint = THSTG.UI.POINT_CENTER,
		style = {
			size = THSTG.UI.FONT_SIZE_SMALLER,
			color = THSTG.UI.getColorHtml("#fcf5c2")
		}
	})
    node:addChild(_uiDescText)
    
    --用于检查是否能够移动
    _timerCheckMove = THSTG.Scheduler.schedule(function ()
        if not _varIsCanMove then
            _varLstTime = _varLstTime + 1
            if _varLstTime >= DELAY_TIME then
                _varIsCanMove = true
                _varLstTime = 0
            end
        end    
    end, 1)

    --------Control--------
    _selectedChangedHandle = function (sender,tnode, index, value, lastIndex, lastValue)
        local data = _uiTitleList:getDataProvider()[index]
        _uiDescText:setText(data.desc)
        _varIsCanMove = false
        _varLstTime = 0
       
        --当且仅当二次选中后进入
        if index == lastIndex then
            if data.onClick then
                data.onClick(sender)
            end
            if data.file and  data.file ~= "" then
                --TODO:需要一个全局Layer,进行 入栈出栈操作的那种,这个layer 进别的层时先 入栈
                local file = require (data.file)
                local layer = file.create()
                -- node:setVisible(false)
                node:addChild(layer)
                
            end
        end
    end

    function node.updateLayer()
        local infos = MainMenuConfig.getMainMenuInfo()
        _uiTitleList:setDataProvider(infos)
        _uiTitleList:setSelected(1)
    end

    function node.destoyTimer()
        if _timerCheckMove then
            THSTG.Scheduler.unschedule(_timerCheckMove)
            _timerCheckMove = nil
        end
    end
    node:onNodeEvent("enter", function ()
        node.updateLayer()
	end)

	node:onNodeEvent("exit", function ()
        node.destoyTimer()
    end)

    return node
end
return M