local EGameKeyType = Definition.Public.EGameKeyType
local ETouchType = Definition.Public.ETouchType
local ANIMATE_PATH = "Scripts.Context.Game.Modules.Stage.Config.Animation.%s"
local M = class("PlayerAnimationSystem",THSTG.ECS.System)

function M:_onInit()
    self.roleType = StageDefine.RoleType.REIMU

end
function M:getAnime(action,sprite)
    local path = string.format(ANIMATE_PATH,self.roleType)
    local dict = require(path)
    return dict[action]
end
function M:play(action)
    local animationComp = self:getComponent("AnimationComponent")
    local sprite = animationComp.sprite
    --查找配置
    local actionFunc = self:getAnime(action)
    actionFunc(sprite)
end

function M:_onKeyMoveAnime(keyMapper)
    if keyMapper:isKeyDown(EGameKeyType.MoveLeft) then
        self:play(StageDefine.ActionType.MOVE_LEFT)
    elseif keyMapper:isKeyDown(EGameKeyType.MoveRight) then
        self:play(StageDefine.ActionType.MOVE_RIGHT)
    else
        self:play(StageDefine.ActionType.STAND)
    end
   
end
function M:_onTouchMoveAnime(touchPos)

end



function M:_onUpdate()
    local inputComp = self:getComponent("InputComponent")
    local keyMapper = inputComp.keyMapper
    local touchPos = inputComp.touchPos
    self:_onKeyMoveAnime(keyMapper)
    self:_onTouchMoveAnime(touchPos)

end

return M

