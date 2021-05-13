--[[

Credits:

-- GGshor

------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------

The simple way of using this TweenModel.
Only needs a primarypart

Example:

local TweenModel = require(6019253834) -- Get the module. Use id to get most updated version!

TweenModel.Model = script.Parent.Door -- Which model should be moved. (SET THE PRIMARYPART, to something in the middle or something)
TweenModel.Goal = script.Parent.Goal -- Where should the model move to. (Should be a dupe of the PrimaryPart and out of the model you are moving, so it doesn't move incorrect)
TweenModel.Duration = 5 -- How much time it take to move the model. (Default = 1)
TweenModel.Style = TweenModel.TypeStyles.Linear -- What for tweening style. (Default = TweenModel.TypeStyles.Quad)
TweenModel.Direction = TweenModel.TypeDirections.In -- What for direction. (Default = TweenModel.TypeDirections.Out)
TweenModel.Repeat = 0 -- How many times should it repeat. (Default = 0)
TweenModel.Reverses = false -- Should it go back. (Default = false)
TweenModel.Delay = 0 -- Should it wait before moving and going back.

TweenModel:Play() -- Plays the tween.

------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////
------------------------------------------------------------------------------

You can also play it in one line.
Still needs a primarypart

EXAMPLE:

local TweenModel = require(6019253834) -- Get the module. Use id to get most updated version!

TweenModel:PlayInstant(script.Parent.Door,script.Parent.Goal,5,TweenModel.TypeStyles.Linear,TweenModel.TypeDirections.In,0,false,0)

------------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////
-------------------------------------------------------------------------------
--]]

local TweenModel = {
	["Model"] = nil,
	["Goal"] = nil,
	["Duration"] = nil,
	["Style"] = nil,
	["Direction"] = nil,
	["Repeat"] = nil,
	["Reverses"] = nil,
	["Delay"] = nil,
	["TypeDirections"] = {
		["In"] = Enum.EasingDirection.In,
		["InOut"] = Enum.EasingDirection.InOut,
		["Out"] = Enum.EasingDirection.Out
	},
	["TypeStyles"] = {
		["Back"] = Enum.EasingStyle.Back,
		["Bounce"] = Enum.EasingStyle.Bounce,
		["Circular"] = Enum.EasingStyle.Circular,
		["Cubic"] = Enum.EasingStyle.Cubic,
		["Elastic"] = Enum.EasingStyle.Elastic,
		["Exponential"] = Enum.EasingStyle.Exponential,
		["Linear"] = Enum.EasingStyle.Linear,
		["Quad"] = Enum.EasingStyle.Quad,
		["Quart"] = Enum.EasingStyle.Quart,
		["Quint"] = Enum.EasingStyle.Quint,
		["Sine"] = Enum.EasingStyle.Sine
	}
}


local warn = function(...)
	for _,msg in pairs({...}) do
		warn("--{ Tween Model }-- " .. tostring(msg))
	end
end

local function CheckGoal(goal)
	local Yep = pcall(function()
		return goal.CFrame
	end)
	return Yep
end
local function CheckStyle(sty)
	for _,style in pairs(TweenModel.TypeStyles) do
		if style == sty then
			return true
		end
	end
	return false
end
local function CheckDirect(dire)
	for _,direct in pairs(TweenModel.TypeDirections) do
		if direct == dire then
			return true
		end
	end
	return false
end

function CheckTypes(Mode,Model,Goal,Duration,Style,Direction,Repeat,Reverses,Delay)
	if Mode == "Normal" then
		if TweenModel.Model:IsA("Model")then else warn(tostring(TweenModel.Model) .. " is not a model!") return false end
		if TweenModel.Model.PrimaryPart then else warn("No PrimaryPart found! Add a PrimaryPart via the model properties!") return false end
		if CheckGoal(TweenModel.Goal) then else warn(tostring(TweenModel.Goal) .. " is not a part or union!") return false end
		if CheckStyle(TweenModel.Style) then else warn("Style has to be a style! (Example: TweenModel.TypeStyles.Quad") return false end
		if CheckDirect(TweenModel.Direction) then else warn("Direction has to be a direction! (Example: TweenModel.TypeDirections.Out)") return false end
		if type(TweenModel.Duration) == "number" then else warn(" Duration has to be a number!") return false end
		if type(TweenModel.Repeat) == "number" then else warn("Repeat has to be a number!") return false end
		if type(TweenModel.Reverses)== "boolean" then else warn("Reverses has to be a true or false!") return false end
		if type(TweenModel.Delay) == "number" then else warn("Delay has to be a number!") return false end
	elseif Mode == "Instant" then
		if Model:IsA("Model")then else warn(tostring(Model) .. " is not a model!") return false end
		if Model.PrimaryPart then else warn("No PrimaryPart found! Add a PrimaryPart via the model properties!") return false end
		if CheckGoal(Goal) then else warn(tostring(Goal) .. " is not a part or union!") return false end
		if CheckStyle(Style) then else warn("Style has to be a style! (Example: TweenModel.TypeStyles.Quad") return false end
		if CheckDirect(Direction) then else warn("Direction has to be a direction! (Example: TweenModel.TypeDirections.Out)") return false end
		if type(Duration) == "number" then else warn("Duration has to be a number!") return false end
		if type(Repeat) == "number" then else warn("Repeat has to be a number!") return false end
		if type(Reverses)== "boolean" then else warn("Reverses has to be a true or false!") return false end
		if type(Delay) == "number" then else warn("Delay has to be a number!") return false end
	end
end

function TweenModel:Play()
	
	if TweenModel.easingStyle then
		warn("Please update your code! I have updated the module, please read the examples.")
		return
	end
	
	if not TweenModel.Model then
		warn("You have to set a Model before playing the tween!")
		return
	end
	if not TweenModel.Goal then
		warn("You have to set a Goal before playing the tween!")
		return
	end
	
	if TweenModel.Duration == nil then
		TweenModel.Duration = 1
	end
	if TweenModel.Style == nil then
		TweenModel.Style = TweenModel.TypeStyles.Quad
	end
	if TweenModel.Direction == nil then
		TweenModel.Direction = TweenModel.TypeDirections.Out
	end
	if TweenModel.Repeat == nil then
		TweenModel.Repeat = 0
	end
	if TweenModel.Reverses == nil then
		TweenModel.Reverses = false
	end
	if TweenModel.Delay == nil then
		TweenModel.Delay = 0
	end
	
	if CheckTypes("Normal") == false then
		return
	end
	
	local succes,response = pcall(function()
		local tweenService = game:GetService("TweenService")
		local info = TweenInfo.new(TweenModel.Duration, TweenModel.Style, TweenModel.Direction, TweenModel.Repeat, TweenModel.Reverses, TweenModel.Delay)
		local function run(model, CF)
			local CFrameValue = Instance.new("CFrameValue")
			CFrameValue.Value = model:GetPrimaryPartCFrame()

			CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
				model:SetPrimaryPartCFrame(CFrameValue.Value)
			end)

			local tween = tweenService:Create(CFrameValue, info, {Value = CF})
			tween:Play()

			tween.Completed:Connect(function()
				CFrameValue:Destroy()
				return
			end)
		end
		wait()
		run(TweenModel.Model, TweenModel.Goal.CFrame)
	end)
	if not succes then return error(response) end
end

function TweenModel:PlayInstant(Model,Goal,Duration,Style,Direction,Repeat,Reverses,Delay)
	
	if not Model then
		warn("You have to set a Model before playing a tween!")
		return
	end
	if not Goal then
		warn("You have to set a Goal before playing a tween!")
		return
	end
	
	if Duration == nil then
		Duration = 1
	end
	if Style == nil then
		Style = TweenModel.TypeStyles.Quad
	end
	if Direction == nil then
		Direction = TweenModel.TypeDirections.Out
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
	
	if CheckTypes("Instant",Model,Goal,Duration,Style,Direction,Repeat,Reverses,Delay) == false then
		return
	end
	
	local succes,response = pcall(function()	
		local tweenService = game:GetService("TweenService")
		local info = TweenInfo.new(Duration,Style,Direction,Repeat,Reverses,Delay)

		local function run(model, CF)
			local CFrameValue = Instance.new("CFrameValue")
			CFrameValue.Value = model:GetPrimaryPartCFrame()

			CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
				model:SetPrimaryPartCFrame(CFrameValue.Value)
			end)

			local tween = tweenService:Create(CFrameValue, info, {Value = CF})
			tween:Play()

			tween.Completed:Connect(function()
				CFrameValue:Destroy()
				return
			end)
		end
		wait()
		run(Model, Goal.CFrame)
	end)
	if not succes then return error(response) end
end

return TweenModel