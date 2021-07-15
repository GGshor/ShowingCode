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
local TweenService = game:GetService("TweenService")


function TweenModel.new(Model,TweenInfo,Goal)
	local IsModel, _  = pcall(function()
		if Model.PrimaryPart then
			return
		else
			return
		end
	end)

	if IsModel == false then
		warn(expectgot:format("Model",typeof(Model)))
		return
	end
	if typeof(Goal) ~= "CFrame" then
		warn(expectgot:format("CFrame",typeof(Goal)))
		return
	end

	if typeof(TweenInfo) ~= "TweenInfo" then
		warn(expectgot:format("TweenInfo",typeof(TweenInfo)))
		return
	end

	local CF = Instance.new("CFrameValue")
	CF.Value = Model:GetPrimaryPartCFrame()

	CF:GetPropertyChangedSignal('Value'):Connect(function()
		Model:SetPrimaryPartCFrame(CF.Value)
	end)

	local CreatedTween = TweenService:Create(CF,TweenInfo,{Value = Goal})

	return CreatedTween
end

function TweenModel:Play()
	error("Deprecated method of using TweenModel module detected, please update your code!",0)
end

function TweenModel:PlayInstant(Model,Goal,Duration,Style,Direction,Repeat,Reverses,Delay)
	warn("\n-------------------------\n\nDeprecated method of using TweenModule detected, please update your code!\n\nBackwards compatibility may NOT work with your code!\n\n-------------------------")

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

end

return TweenModel