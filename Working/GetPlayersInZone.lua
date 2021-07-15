local mod = {}
function mod:GetPlayers(zone)
	local Catched = {}
	
	local function isInsideBrick(root,part) -- Making function to get root and part
		local function GetTouchingParts(part)
			local connection = part.Touched:Connect(function() end)
			local results = part:GetTouchingParts()
			connection:Disconnect()
			return results
		end
		local results = GetTouchingParts(part)
		for i,v in pairs(results) do
			if v == root then
				return true
			end
		end
	end

	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do -- Gets all players
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") -- Gets player character and checks if loaded
		if (hrp and isInsideBrick(player.Character.HumanoidRootPart,zone)) then -- Checks if players is inside the zone
			table.insert(Catched,player)
		end
	end
	return Catched
end
return mod