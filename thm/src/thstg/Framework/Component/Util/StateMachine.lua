

M = class("StateMachine")

--[[--

port from Javascript State Machine Library

https://github.com/jakesgordon/javascript-state-machine

JS Version: 2.2.0

]]

M.VERSION = "2.2.0"

-- the event transitioned successfully from one state to another
M.SUCCEEDED = 1
-- the event was successfull but no state transition was necessary
M.NOTRANSITION = 2
-- the event was cancelled by the caller in a beforeEvent callback
M.CANCELLED = 3
-- the event is asynchronous and the caller is in control of when the transition occurs
M.PENDING = 4
-- the event was failure
M.FAILURE = 5

-- caller tried to fire an event that was innapropriate in the current state
M.INVALID_TRANSITION_ERROR = "INVALID_TRANSITION_ERROR"
-- caller tried to fire an event while an async transition was still pending
M.PENDING_TRANSITION_ERROR = "PENDING_TRANSITION_ERROR"
-- caller provided callback function threw an exception
M.INVALID_CALLBACK_ERROR = "INVALID_CALLBACK_ERROR"

M.WILDCARD = "*"
M.ASYNC = "ASYNC"

function M:ctor()
    
end

function M:setupState(cfg)
    assert(type(cfg) == "table", "StateMachine:ctor() - invalid config")

    -- cfg.initial allow for a simple string,
    -- or an table with { state = "foo", event = "setup", defer = true|false }
    if type(cfg.initial) == "string" then
        self.initial_ = {state = cfg.initial}
    else
        self.initial_ = clone(cfg.initial)
    end

    self.terminal_   = cfg.terminal or cfg.final
    self.events_     = cfg.events or {}
    self.callbacks_  = cfg.callbacks or {}
    self.map_        = {}
    self.current_    = "None"
    self.inTransition_ = false

    if self.initial_ then
        self.initial_.event = self.initial_.event or "Startup"
        self:addEvent_({name = self.initial_.event, from = "None", to = self.initial_.state})
    end

    for _, event in ipairs(self.events_) do
        self:addEvent_(event)
    end

    if self.initial_ and not self.initial_.defer then
        self:doEvent(self.initial_.event)
    end

    return self
end

function M:isReady()
    return self.current_ ~= "None"
end

function M:getState()
    return self.current_
end

function M:isState(state)
    if type(state) == "table" then
        for _, s in ipairs(state) do
            if s == self.current_ then return true end
        end
        return false
    else
        return self.current_ == state
    end
end

function M:canDoEvent(eventName)
    return not self.inTransition_
        and (self.map_[eventName][self.current_] ~= nil or self.map_[eventName][M.WILDCARD] ~= nil)
end

function M:cannotDoEvent(eventName)
    return not self:canDoEvent(eventName)
end

function M:isFinishedState()
    return self:isState(self.terminal_)
end

function M:doEventForce(name, ...)
    local from = self.current_
    local map = self.map_[name]
    local to = (map[from] or map[M.WILDCARD]) or from
    local args = {...}

    local event = {
        name = name,
        from = from,
        to = to,
        args = args,
    }

    if self.inTransition_ then self.inTransition_ = false end
    self:beforeEvent_(event)
    if from == to then
        self:afterEvent_(event)
        return M.NOTRANSITION
    end

    self.current_ = to
    self:enterState_(event)
    self:changeState_(event)
    self:afterEvent_(event)
    return M.SUCCEEDED
end

function M:doEvent(name, ...)
    assert(self.map_[name] ~= nil, string.format("doEvent() - invalid event %s", tostring(name)))

    local from = self.current_
    local map = self.map_[name]
    local to = (map[from] or map[M.WILDCARD]) or from
    local args = {...}

    local event = {
        name = name,
        from = from,
        to = to,
        args = args,
    }

    if self.inTransition_ then
        self:onError_(event,
                      M.PENDING_TRANSITION_ERROR,
                      "event " .. name .. " inappropriate because previous transition did not complete")
        return M.FAILURE
    end

    if self:cannotDoEvent(name) then
        self:onError_(event,
                      M.INVALID_TRANSITION_ERROR,
                      "event " .. name .. " inappropriate in current state " .. self.current_)
        return M.FAILURE
    end

    if self:beforeEvent_(event) == false then
        return M.CANCELLED
    end

    if from == to then
        self:afterEvent_(event)
        return M.NOTRANSITION
    end

    event.transition = function()
        self.inTransition_  = false
        self.current_ = to -- this method should only ever be called once
        self:enterState_(event)
        self:changeState_(event)
        self:afterEvent_(event)
        return M.SUCCEEDED
    end

    event.cancel = function()
        -- provide a way for caller to cancel async transition if desired
        event.transition = nil
        self:afterEvent_(event)
    end

    self.inTransition_ = true
    local leave = self:leaveState_(event)
    if leave == false then
        event.transition = nil
        event.cancel = nil
        self.inTransition_ = false
        return M.CANCELLED
    elseif string.upper(tostring(leave)) == M.ASYNC then
        return M.PENDING
    else
        -- need to check in case user manually called transition()
        -- but forgot to return M.ASYNC
        if event.transition then
            return event.transition()
        else
            self.inTransition_ = false
        end
    end
end

function M:addEvent_(event)
    local from = {}
    if type(event.from) == "table" then
        for _, name in ipairs(event.from) do
            from[name] = true
        end
    elseif event.from then
        from[event.from] = true
    else
        -- allow "wildcard" transition if "from" is not specified
        from[M.WILDCARD] = true
    end

    self.map_[event.name] = self.map_[event.name] or {}
    local map = self.map_[event.name]
    for fromName, _ in pairs(from) do
        map[fromName] = event.to or fromName
    end
end

local function doCallback_(callback, event)
    if callback then return callback(event) end
end

function M:beforeAnyEvent_(event)
    return doCallback_(self.callbacks_["onBeforeEvent"], event)
end

function M:afterAnyEvent_(event)
    return doCallback_(self.callbacks_["onAfterEvent"] or self.callbacks_["onEvent"], event)
end

function M:leaveAnyState_(event)
    return doCallback_(self.callbacks_["onLeaveState"], event)
end

function M:enterAnyState_(event)
    return doCallback_(self.callbacks_["onEnterState"] or self.callbacks_["onState"], event)
end

function M:changeState_(event)
    return doCallback_(self.callbacks_["onChangeState"], event)
end

function M:beforeThisEvent_(event)
    return doCallback_(self.callbacks_["onBefore" .. event.name], event)
end

function M:afterThisEvent_(event)
    return doCallback_(self.callbacks_["onAfter" .. event.name] or self.callbacks_["on" .. event.name], event)
end

function M:leaveThisState_(event)
    return doCallback_(self.callbacks_["onLeave" .. event.from], event)
end

function M:enterThisState_(event)
    return doCallback_(self.callbacks_["onEnter" .. event.to] or self.callbacks_["on" .. event.to], event)
end

function M:beforeEvent_(event)
    if self:beforeThisEvent_(event) == false or self:beforeAnyEvent_(event) == false then
        return false
    end
end

function M:afterEvent_(event)
    self:afterThisEvent_(event)
    self:afterAnyEvent_(event)
end

function M:leaveState_(event, transition)
    local specific = self:leaveThisState_(event, transition)
    local general = self:leaveAnyState_(event, transition)
    if specific == false or general == false then
        return false
    elseif string.upper(tostring(specific)) == M.ASYNC
        or string.upper(tostring(general)) == M.ASYNC then
        return M.ASYNC
    end
end

function M:enterState_(event)
    self:enterThisState_(event)
    self:enterAnyState_(event)
end

function M:onError_(event, error, message)
    printf("ERROR: error %s, event %s, from %s to %s", tostring(error), event.name, event.from, event.to)
    print(string.format("[%s] %s", string.upper(tostring("ERR")), string.format(tostring(message))))
    print(debug.traceback("", 2))
end

return M