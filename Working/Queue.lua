--[[
    New module that I'm working on, not finished lol

    TODO:
    * Create queue system
    * Fix metatable not working
    * Finish wait system
]]

local Queue = {}

local function createIndex(oldTable)
	local newTable = {}

	for _,stuff in pairs(oldTable) do
		table.insert(newTable, (#newTable + 1), stuff)
	end

	return newTable
end

local sortTable = createIndex -- Because I'm too lazy

function Queue.new(newQueue)
	local self = {}
	
	self._queue = {}
	self._last = nil
	self._paused = false

	self._onRemoveInstance = Instance.new("BindableEvent")
	self._onAddInstance = Instance.new("BindableEvent")
	self.onAdd = self._onAddInstance.Event
	self.onRemove = self._onRemoveInstance.Event

	if newQueue ~= nil then
		assert(typeof(newQueue) == "table", ("Expected table, got %s"):format(typeof(newQueue)))
		self._queue = createIndex(newQueue)
	end

	task.spawn(function()
		if self._queue ~= nil then
			local current = self._queue[1]
			self._onRemoveInstance:Fire(current)
			
		end
	end)
	print("Returning table")
	
	return setmetatable(self, Queue)
end


function Queue:pause()
	self._paused = true
end

function Queue:resume()
	self._paused = false
end

function Queue:add(add)
	if typeof(add) == "table" then
		for _,object in pairs(add) do
			table.insert(self._queue, (#self._queue + 1), add)
		end
	else
		print(self._queue)
		table.insert(self._queue, (#self._queue + 1), add)
	end
end

function Queue:getRemaining()
	return self._queue
end

function Queue:getLast()
	return self._last
end

return Queue
