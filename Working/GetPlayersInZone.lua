--[[
	@GGshor
	Gets players touching a part.
--]]


--// Services
local Players = game:GetService("Players")


--[[
TheNexusAvenger

Determines if a CFrame is in a part.
--]]
function isCFrameInPart(Part: BasePart, TestCFrame: CFrame)
	local RelativePosition = Part.CFrame:Inverse() * TestCFrame
	local Size = Part.Size
	return math.abs(RelativePosition.X) <= Size.X / 2 and math.abs(RelativePosition.Y) <= Size.Y / 2 and math.abs(RelativePosition.Z) <= Size.Z / 2
end


--// Module return
--[[
	Returns table with players, if none are found returns false
--]]
return function(part: BasePart, timeout: number?): {Player}
	local found: {Player} = {} -- Table for the players found

	if timeout <= 1 then -- Just a check to make sure that the timeOut can't be 0 or less.
		timeout = false
	end

	if timeout then -- If there is a timeout use waitforchild
		for _, player: Player in pairs(Players:GetPlayers()) do
			task.spawn(function()
				if player.Character and player.Character:WaitForChild("HumanoidRootPart", (timeout - 1)) then					
					if isCFrameInPart(part, player.Character.HumanoidRootPart.CFrame) then
						table.insert(found, player)
					end
				end
			end)
		end

		task.wait(timeout)

	else -- Else just don't use waitforchild
		for _, player: Player in pairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				if isCFrameInPart(part, player.Character.HumanoidRootPart.CFrame) then
					table.insert(found, player)
				end
			end
		end
	end

	return found
end
