--[[

Credits:

-- GGshor

------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------

The simple way of using this TweenModel.
Only needs a primarypart and everything needs to be anchored

Example:

local TweenModel = require(6019253834) -- Get the module. Use id to get most updated version!

local Tween = TweenModel.new( -- Creates a new tween
	script.Parent.Door, -- Which model should be moved. (SET THE PRIMARYPART, to something in the middle or something)
	TweenInfo.new(
		5, -- Amount of seconds it take. (Default = 1)
		Enum.EasingStyle.Linear, -- Style of tween. (Default = TweenModel.TypeStyles.Quad)
		Enum.EasingDirection.Out, -- Type of direction. (Default = TweenModel.TypeDirections.Out)
		0, -- How many times should it repeat. (Default = 0)
		false, -- -- Should it go back. (Default = false)
		0 -- Amount of seconds it will wait before playing the tween again. (Default = 0)
	),
	script.Parent.Goal.CFrame -- Where should the model move to. (Should be a dupe of the PrimaryPart and out of the model you are moving, so it doesn't move incorrect)
)

Tween:Play() -- Plays the tween.

------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------
--]]

local TweenModel = {}

local expectgot = "%s expected, got %s"
local Tween = game:GetService("TweenService")

local warn = function(Data) for _,m in pairs({Data}) do warn(" { Tween-Model Module } -- " .. tostring(m)) end end
local print = function(Data) for _,m in pairs({Data}) do print(" { Tween-Model Module } -- " .. tostring(m)) end end

function TweenModel.new(Model,Info,Goal)
	local IsModel, _  = pcall(function()
		if Model.PrimaryPart then
			return
		else
			return
		end
	end)

	local IsCFrame, CheckedCFrame = pcall(function()
		if typeof(Goal) == "CFrame" then
			return Goal
		else
			if Goal.CFrame then
				return Goal.CFrame
			end
		end
	end)

	if IsModel == false then
		warn(expectgot:format("Model",typeof(Model)))
		return
	end

	if IsCFrame == false then
		warn(expectgot:format("CFrame/Instance",typeof(Goal)))
		return
	end

	if typeof(Info) ~= "TweenInfo" then
		warn(expectgot:format("TweenInfo",typeof(Info)))
		return
	end

	local CF = Instance.new("CFrameValue")
	CF.Value = Model:GetPrimaryPartCFrame()
	CF.Changed:Connect(function()
		Model:SetPrimaryPartCFrame(CF.Value)
	end)

	local CreatedTween = Tween:Create(CF,Info,{Value = CheckedCFrame})

	return CreatedTween
end

function TweenModel:Play()
	error(" { Tween-Model Module } -- Deprecated method of using TweenModel module detected, please update your code!",0)
end

function TweenModel:PlayInstant(Model,Goal,Duration,Style,Direction,Repeat,Reverses,Delay)
	if typeof(Goal) ~= "TweenInfo" then -- If goal isn't using the new way then use deprecated method
		if Duration == nil then
			Duration = 1
		end
		if Style == nil then
			Style = Enum.EasingStyle.Quad
		end
		if Direction == nil then
			Direction = Enum.EasingDirection.Out
		end
		if Repeat == nil then
			Repeat = 0
		end
		if Reverses == nil then
			Reverses = false
		end
		if Delay == nil then
			Delay = 0
		end

		local info = TweenInfo.new(Duration,Style,Direction,Repeat,Reverses,Delay)

		TweenModel.new(Model,info,Goal.CFrame):Play()
		
	else -- Is using the new way
		local IsCFrame, CheckedCFrame = pcall(function()
			if typeof(Duration) == "CFrame" then
				return Duration
			else
				if Duration.CFrame then
					return Duration.CFrame
				end
			end
		end)

		TweenModel.new(Model,Goal,CheckedCFrame):Play()
	end
end

return TweenModel