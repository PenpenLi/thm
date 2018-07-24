module(..., package.seeall)

local M = {}
function M.create(params)
    local layer = THSTG.UI.newLayer()

    --精灵菜单的使用
    local s1=cc.Sprite:create("res/close.png")
    local s2=cc.Sprite:create("res/open.png")
    local spriteBtn=cc.MenuItemSprite:create(s1,s2)
    local function spriteBtnCB(sender) 
        print("精灵菜单")
    end
    spriteBtn:registerScriptTapHandler(spriteBtnCB)
    local spriteMenu=cc.Menu:create(spriteBtn)      --添加到menu中，不需要最后加null
    spriteMenu:alignItemsHorizontally()             --水平排列
    layer:addChild(spriteMenu)

    --MenuItemFont的使用
    cc.MenuItemFont:setFontName("Times New Roman")
    cc.MenuItemFont:setFontSize(86)
    local item1=cc.MenuItemFont:create("Start")
    local function menuItemCallback1(sender)          --按钮回调函数
        print("文字菜单1")
    end
    item1:registerScriptTapHandler(menuItemCallback1) --注册回调函数
    local item2=cc.MenuItemFont:create("End")
    local function menuItemCallback2(sender)          --按钮回调函数
        print("文字菜单2")
    end
    item2:registerScriptTapHandler(menuItemCallback2) --注册回调函数
    local itemMenu=cc.Menu:create(item1,item2)        --添加到menu中，不需要最后加null
    itemMenu:alignItemsHorizontallyWithPadding(100)   --水平中排列-间距
    layer:addChild(itemMenu)

    --图片菜单的使用
    local ImageBtn1=cc.MenuItemImage:create("res/close.png","res/open.png")
    local function imageBtnCB(sender) 
        print("图片菜单1")
    end
    ImageBtn1:registerScriptTapHandler(imageBtnCB)

    local ImageBtn2=cc.MenuItemImage:create("res/close.png","res/open.png")
    local function imageBtnCB(sender) 
        print("图片菜单2")
    end
    ImageBtn2:registerScriptTapHandler(imageBtnCB)
    local ImageMenu=cc.Menu:create(ImageBtn1,ImageBtn2)             --添加到menu中，不需要最后加null
    ImageMenu:alignItemsVerticallyWithPadding(100)                  --居中排列-间距
    layer:addChild(ImageMenu)


    --开关菜单的使用
    local spriteTBtn=cc.MenuItemSprite:create(cc.Sprite:create("res/open.png"),cc.Sprite:create("res/close.png"))
    local function spriteBtnCBT(sender) 
        print("开关精灵菜单")
    end
    spriteTBtn:registerScriptTapHandler(spriteBtnCBT)
    local ImageTBtn=cc.MenuItemImage:create("res/close.png","res/open.png")
    local function imageBtnCBT(sender) 
        print("开关图片菜单")
    end
    ImageTBtn:registerScriptTapHandler(imageBtnCBT)
    local toggleBtn=cc.MenuItemToggle:create(spriteTBtn,ImageTBtn)
    local function toggleCB() 
        print("toggleCB")
    end
    toggleBtn:registerScriptTapHandler(toggleCB)
    local toggleMenu=cc.Menu:create(toggleBtn)  --添加到menu中，不需要最后加null
    toggleMenu:alignItemsVertically()           --居中排列
    layer:addChild(toggleMenu)

   


    return layer
end
return M