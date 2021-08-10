--[[
    New module that I'm working on, not finished as it is midnight lol

    TODO:
    * Create queue system
    * Able to add/remove from queue

]]

local Queue = {}

function Queue.new(newQueue)
    local self = {}

    self._queue = {}
    self._last = nil
    self._onRemoveInstance = Instance.new("BindableEvent")
    self.onRemove = self._onRemoveInstance.Event

    return setmetatable(self, Queue)
end

function Queue:getRemaining()
    return self._queue
end

function Queue:getLast()
    return self._last
end

return Queue