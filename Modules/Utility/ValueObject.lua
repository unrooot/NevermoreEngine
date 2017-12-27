--- To work like value objects in ROBLOX and track a single item,
-- with `.Changed` events
-- @classmod ValueObject

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("NevermoreEngine"))

local Signal = require("Signal")

local ValueObject = {}
ValueObject.ClassName = "ValueObject"

--- Constructs a new value object
-- @constructor
-- @treturn ValueObject
function ValueObject.new()
	local self = setmetatable({}, ValueObject)
	
	--- The value of the ValueObject
	-- @tfield Variant Value

	--- Event fires when the value's object value change
	-- @signal Changed
	-- @tparam Variant NewValue The new value
	-- @tparam Variant OldValue The old value
	self.Changed = Signal.new() -- :Fire(NewValue, OldValue)
	
	return self
end



function ValueObject:__index(Index)
	if Index == "Value" then
		return self._Value
	elseif Index == "_Value" then
		return nil -- Edge case.
	elseif ValueObject[Index] then
		return ValueObject[Index]
	else
		error("'" .. tostring(Index) .. "' is not a member of ValueObject")
	end
end

function ValueObject:__newindex(Index, Value)
	if Index == "Value" then
		if self.Value ~= Value then
			local Old = self.Value
			self._Value = Value
			self.Changed:Fire(Value, Old)
		end
	elseif Index == "_Value" then
		rawset(self, Index, Value)
	elseif Index == "Changed" then
		rawset(self, Index, Value)
	else
		error("'" .. tostring(Index) .. "' is not a member of ValueObject")
	end
end

return ValueObject