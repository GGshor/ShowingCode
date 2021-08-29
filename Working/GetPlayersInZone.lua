local GetPlayersInZone = {}

local function isInsideBrick(root,part) -- Making function to get root and part
	local function GetTouchingParts(part)
		local notEnabled = false
		if part.CanTouch == false then
			notEnabled = true
			part.CanTouch = true
		end
		local connection = part.Touched:Connect(function() end)
		local results = part:GetTouchingParts()
		connection:Disconnect()
		if notEnabled then
			part.CanTouch = false
		end
		return results
	end
	local results = GetTouchingParts(part)
	for i,v in pairs(results) do
		if v == root then
			return true
		end
	end
end

function GetPlayersInZone:GetPlayers(zone)
	local Catched = {}

	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do -- Gets all players
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") -- Gets player character and checks if loaded
		if (hrp and isInsideBrick(player.Character.HumanoidRootPart,zone)) then -- Checks if players is inside the zone
			table.insert(Catched,player)
		end
	end
	return Catched
end

function GetPlayersInZone:IsInZone(player, zone)
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") -- Gets player character and checks if loaded
	if (hrp and isInsideBrick(player.Character.HumanoidRootPart,zone)) then -- Checks if players is inside the zone
		return true
	else
		return false
	end
end

return mod
