module(..., package.seeall)

local M = {}
function M.create(params)
    --------Model--------
   

    --------View--------
    local node = THSTG.UI.newNode()

    local bg = UIPublic.newSheetSprite({
        x = display.cx,
        y = display.cy,
        anchorPoint = THSTG.UI.POINT_CENTER,
        sheet = "stg01_bg"
    })
    node:addChild(bg)
    
    local cloud01 = UIPublic.newSheetSprite({
        x = display.cx-50,
        y = 0,
        anchorPoint = THSTG.UI.POINT_CENTER,
        sheet = "stg01_cloud_01"
    })
    cloud01:setPositionY(-cloud01:getContentSize().height)
    node:addChild(cloud01)

    local cloud02 = UIPublic.newSheetSprite({
        x = display.cx+50,
        y = 0,
        anchorPoint = THSTG.UI.POINT_CENTER,
        sheet = "stg01_cloud_02"
    })
    cloud02:setPositionY(-cloud02:getContentSize().height)
    node:addChild(cloud02)

    local function initAction()
        local function makeAction(node,time)
            local array = {
                cc.CallFunc:create(function ()
                    node:setScale(1.0)
                    node:setPositionY(-node:getContentSize().height)
                end),
                cc.Spawn:create({
                    cc.MoveTo:create(time, cc.p(node:getPositionX(), display.cy)),
                    cc.ScaleTo:create(time, 0),
                }),
            }
            return cc.RepeatForever:create(cc.Sequence:create(array))
        end
        cloud01:runAction(makeAction(cloud01,8.0))
        cloud02:runAction(makeAction(cloud02,10.0))
    end

    local function init()
        initAction()
    end
    init()
    --------Controller--------
  
    node:onNodeEvent("enter", function ()
       
	end)

	node:onNodeEvent("exit", function ()

    end)

    return node
end
return M