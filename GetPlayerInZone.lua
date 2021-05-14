function isInsideBrick(brick,zone) -- Making function to get part and zone
	local function GetTouchingParts(part)
		local connection = part.Touched:Connect(function() end)
		local results = part:GetTouchingParts()
		connection:Disconnect()
		return results
	end
	local results = GetTouchingParts(zone)
	for i,v in pairs(results) do
		if v == brick then
			return true
		end
	end
end

function GetPlayers(zone) -- Making function to start finding players and changing them
    local Catched = {}
	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do -- Gets all players
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart") -- Gets player character and checks if loaded
		if (hrp and isInsideBrick(player.Character.HumanoidRootPart,zone)) then -- Checks if players is inside the zone
            table.insert(Catched,player)
        end
    end
    return Catched
end