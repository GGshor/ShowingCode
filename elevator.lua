local module = {
	start = function(ref,cfg)		
		--/ Cobalt /--
		script = nil
		
		--/ Blacklist /--
		
		-- Blacklist Levels:
		-- 1 = Cannot run Cobalt in their games
		-- 2 = Cannot enter a Cobalt lift
		-- 3 = Cannot join games with Cobalt
		-- 4 = Friends cannot join games with Cobalt
		
		local blacklist = {
            -- [UserId] = level
		}
		game.Players.PlayerAdded:connect(function(player)
			if blacklist[player.UserId] then
				if blacklist[player.UserId] >= 3 then
					player:Kick("You are blacklisted!")
				end
			else
				for i,v in pairs(blacklist) do
					if v >= 4 then
						if player:IsFriendsWith(i) then
							player:Kick("You are friends with user "..tostring(i))
						end
					end
				end
			end
		end)
		if blacklist[game.CreatorId] then
			if blacklist[game.CreatorId] >= 1 then
				print("Cobalt: Creator is blacklisted")
				return
			end
		end
		
		--/ Variables /--
		local tweenService = game:GetService("TweenService")
		local runService = game:GetService("RunService")
		local emergencyStop = false
		local initialSafety = true
		local travelling = false
		local quickClose = false
		local doorState = false
		local doorTimer = 0
		local nudgeCounter = 0
		local bottomFloor = 256
		local topFloor = -256
		local floor = 1
		local motor = 0
		local velocity = 0
		local motorMode = "idle"
		local releveling = false
		local doorHold = false
		local inService = true
		local safety = true
		local doors = false
		local shaft = ref.Parent.Shaft
		local car = ref.Parent.Car
		local inputs = ""
		local mode = "auto"
		local screens = {}
		local welds = {}
		local calls = {}
		local floorDirs = {}
		local direction = 0
		local idleTimer = 0
		local bodyvelocity
		local bodyposition
		local bodygyro		
		local sequences = {
			["XOXOOXXOOXOOXXOX"] = function()
				doorHold = not doorHold
			end,
			["OOXXOOXOXOOXOOXO"] = function()
				if mode == "priority" then
					mode = "auto"
					doorHold = false
					inService = true
				elseif mode ~= "manual" then
					mode = "priority"
					inService = false
				end
			end,
			["XXOXOOXOOXOXOOOX"] = function()
				if inService then
					inService = false
					wait(0.1)
					inService = true
				end
				if motor ~= 0 and mode == "auto" then
					mode = "manual"
					wait(0.1)
					mode = "auto"
				end
				if motor ~= 0 and mode == "priority" then
					mode = "manual"
					wait(0.1)
					mode = "priority"
				end
			end,
		}
		
		--/ Initialization /--
		for i,v in pairs(car:GetChildren()) do
			if v.Name == "DestPanel" then
				if v:FindFirstChild("SurfaceGui") then
					for k,z in pairs(v.SurfaceGui:GetChildren()) do
						if tonumber(z.Name) then
							z.Visible = true
						end
					end
				end
			end
		end
		if not car:FindFirstChild("Sensor") and cfg.weldPlayers then
			cfg.weldPlayers = false
			print("Cobalt: No weld sensor, disabling weld")
		end
		spawn(function()
			local hubApi = game.ReplicatedStorage:WaitForChild("QTHubAPI",5)
			if hubApi then
				hubApi:Invoke("CobaltSync",ref.Parent)
			end
		end)
		cfg.narrator = cfg.narrator or false
		local voice
		if cfg.narrator then
			voice = Instance.new("Sound",car.Platform)
			voice.SoundId = "rbxassetid://2125274250"
			voice.Volume = 2
			voice.MaxDistance = 20
		end
		if car:FindFirstChild("FrontDoor") then
			for i,v in pairs(car.FrontDoor:GetChildren()) do
				if v.Name == "LED" then
					v.Door.BrickColor = BrickColor.new("Really black")
				end
			end
		end
		if car:FindFirstChild("RearDoor") then
			for i,v in pairs(car.RearDoor:GetChildren()) do
				if v.Name == "LED" then
					v.Door.BrickColor = BrickColor.new("Really black")
				end
			end
		end
		for _,z in pairs(shaft:GetChildren()) do
			if z:FindFirstChild("FrontDoor") then
				for i,v in pairs(z.FrontDoor:GetChildren()) do
					v.Door.CFrame = v.Closed.CFrame
				end
			end
			if z:FindFirstChild("RearDoor") then
				for i,v in pairs(z.RearDoor:GetChildren()) do
					v.Door.CFrame = v.Closed.CFrame
				end
			end
		end
		if car:FindFirstChild("FrontDoor") then
			for i,v in pairs(car.FrontDoor:GetChildren()) do
				v.Door.CFrame = v.Closed.CFrame
			end
		end
		if car:FindFirstChild("RearDoor") then
			for i,v in pairs(car.RearDoor:GetChildren()) do
				v.Door.CFrame = v.Closed.CFrame
			end
		end
		if cfg.liftMusic and car.Platform:FindFirstChild("Music") then
			car.Platform.Music:Play()
		end
		for i,v in pairs(shaft:GetChildren()) do
			calls[tonumber(v.Name)] = false
			floorDirs[tonumber(v.Name)] = false
			if tonumber(v.Name) > topFloor then
				topFloor = tonumber(v.Name)
			end
			if tonumber(v.Name) < bottomFloor then
				bottomFloor = tonumber(v.Name)
			end
		end
		if cfg.weldPlayers then
			car.Sensor.Touched:connect(function() end)
		end
		if not cfg.cframe and not car.Platform:FindFirstChild("BodyVelocity") then
			bodyvelocity = Instance.new("BodyVelocity",car.Platform)
			bodyvelocity.MaxForce = Vector3.new(0,cfg.maxForce,0)
			bodyvelocity.Velocity = Vector3.new(0,0,0)
			bodyposition = Instance.new("BodyPosition",car.Platform)
			bodyposition.MaxForce = Vector3.new(cfg.maxForce,0,cfg.maxForce)
			bodyposition.Position = car.Platform.Position
			bodygyro = Instance.new("BodyGyro",car.Platform)
			bodygyro.CFrame = car.Platform.CFrame
			bodygyro.MaxTorque = Vector3.new(cfg.maxForce,cfg.maxForce,cfg.maxForce)
		elseif not cfg.cframe then
			bodyvelocity = car.Platform.BodyVelocity
			bodyposition = car.Platform.BodyPosition
			bodygyro = car.Platform.BodyGyro
		end		
		
		--/ Functions /--
		local function weld(p1)
			local w = Instance.new("ManualWeld", car.Platform)
			w.C0 = car.Platform.CFrame:inverse() * p1.CFrame
			w.Part0 = car.Platform
			w.Part1 = p1
			welds[#welds+1] = w
			p1.Anchored = false
		end
		local function weldRecursive(obj)
			for _,v in pairs(obj:GetChildren()) do
				if v.ClassName == "Part" or v.ClassName == "WedgePart" or v.ClassName == "CornerWedgePart" or v.ClassName == "UnionOperation" or v.ClassName == "TrussPart" or v.ClassName == "Seat" or v.ClassName == "MeshPart" then
					weld(v)
				end
				if #v:GetChildren() > 0 then
					weldRecursive(v)
				end
			end
		end
		if car:FindFirstChild("Controls") then
			local clone = car.Controls.Stop:Clone()
			clone.Parent = car.Controls
			clone.Name = "StopPressed"
			clone.ClickDetector:Destroy()
			clone.Transparency = 1
			clone.CanCollide = false
			clone.CFrame = clone.CFrame * CFrame.new(0.05,0,0)
			if clone:FindFirstChild("SurfaceGui") then
				clone.SurfaceGui.Enabled = false
			end
			local clone = car.Controls.Switch:Clone()
			clone.Parent = car.Controls
			clone.Name = "SwitchTurned"
			clone.ClickDetector:Destroy()
			clone.Transparency = 1
			clone.CanCollide = false
			clone.CFrame = clone.CFrame * CFrame.Angles(math.rad(90),0,0)
		end
		if not cfg.cframe then
			weldRecursive(car)
		end
		if ref.Parent:FindFirstChild("Weight") and not cfg.cframe then
			for i,v in pairs(ref.Parent.Motor.Motor:GetChildren()) do
				if v.Name == "Rope" then
					v:Destroy()
				end
			end
			Instance.new("BodyGyro",ref.Parent.Weight.Platform)
			ref.Parent.Weight.Platform.BodyGyro.MaxTorque = Vector3.new(cfg.maxForce,cfg.maxForce,cfg.maxForce)
			ref.Parent.Weight.Platform.BodyGyro.CFrame = ref.Parent.Weight.Platform.CFrame
			Instance.new("BodyPosition",ref.Parent.Weight.Platform)
			ref.Parent.Weight.Platform.BodyPosition.Position = ref.Parent.Weight.Platform.Position
			ref.Parent.Weight.Platform.BodyPosition.MaxForce = Vector3.new(cfg.maxForce,0,cfg.maxForce)
			for i,v in pairs(ref.Parent.Weight:GetChildren()) do
				local w = Instance.new("ManualWeld",ref.Parent.Weight.Platform)
				w.Part0 = ref.Parent.Weight.Platform
				w.Part1 = v
				w.C0 = ref.Parent.Weight.Platform.CFrame:inverse() * v.CFrame
				v.Anchored = false
			end
		end
		local function voiceRoutine()
			wait(0.5)
			voice.TimePosition = voice.TimeLength
			if floor == -1 then
				voice.TimePosition = 0
			elseif floor == 1 then
				voice.TimePosition = 0.5
			elseif floor == 2 then
				voice.TimePosition = 1.25
			elseif floor == 3 then
				voice.TimePosition = 1.9
			elseif floor == 4 then
				voice.TimePosition = 2.4
			elseif floor == 5 then
				voice.TimePosition = 3
			elseif floor == 6 then
				voice.TimePosition = 3.6
			elseif floor == 7 then
				voice.TimePosition = 4.2
			elseif floor == 8 then
				voice.TimePosition = 4.7
			elseif floor == 9 then
				voice.TimePosition = 5.3
			elseif floor == 10 then
				voice.TimePosition = 5.8
			elseif floor == 11 then
				voice.TimePosition = 6.4
			elseif floor == 12 then
				voice.TimePosition = 7
			elseif floor == 13 then
				voice.TimePosition = 7.7
			elseif floor == 14 then
				voice.TimePosition = 8.6
			elseif floor == 15 then
				voice.TimePosition = 9.4
			elseif floor == 16 then
				voice.TimePosition = 10.2
			elseif floor == 17 then
				voice.TimePosition = 11
			elseif floor == 18 then
				voice.TimePosition = 11.8
			elseif floor == 19 then
				voice.TimePosition = 12.5
			elseif floor == 20 then
				voice.TimePosition = 13.2
			elseif floor == 21 then
				voice.TimePosition = 13.95
			elseif floor == 22 then
				voice.TimePosition = 14.9
			elseif floor == 23 then
				voice.TimePosition = 15.9
			elseif floor == 24 then
				voice.TimePosition = 16.8
			end
			if voice.TimePosition ~= voice.TimeLength then
				voice:Play()
				wait(0.65)
				voice:Stop()
				voice.TimePosition = 17.6
				voice:Play()
				wait(0.45)
				voice:Stop()
				wait(0.25)
			end
			wait()
			if floor == bottomFloor then
				direction = 1
			elseif floor == topFloor then
				direction = -1
			end
			if direction == 1 then
				voice.TimePosition = 18.05
				voice:Play()
				wait(0.75)
				voice:Stop()
			elseif direction == -1 then
				voice.TimePosition = 18.8
				voice:Play()
				wait(0.75)
				voice:Stop()
			end
		end
		local function openDoors(bypass)
			--/ Safety Checks /--
			if bypass then
				-- Safety checks bypassed
			elseif math.abs(shaft[tostring(floor)].Level.Position.Y - car.Platform.Position.Y) > (cfg.levelTolerance*10) then
				-- We are too far from the door zone, it is unsafe to open the doors
				return
			elseif nudgeCounter > cfg.reopenLimit then
				-- The door is nudging closed
				return
			elseif mode == "manual" then
				-- We are in manual
				return
			end
			if doors then
				doorTimer = cfg.openTime
				return
			end
			doorState = true
			doors = true
			doorTimer = cfg.openTime
			
			--/ Sound Chime /--
			if floor == bottomFloor then
				direction = 1
			elseif floor == topFloor then
				direction = -1
			end
			if direction == 1 or direction == 0 then
				if cfg.upChime then
					spawn(cfg.upChime)
				end
			elseif direction == -1 then
				if cfg.downChime then
					spawn(cfg.downChime)
				end
			end
			
			--/ Light Lamps /--
			if floorDirs[floor] then
				if direction == 0 then
					direction = floorDirs[floor]
				end
				floorDirs[floor] = false
			end
			if floor == bottomFloor then
				direction = 1
			elseif floor == topFloor then
				direction = -1
			end
			for i,v in pairs(car:GetChildren()) do
				if v.Name == "UpIND" then
					if direction == 1 or direction == 0 then
						v.Material = "Neon"
						v.BrickColor = v.ActiveColor.Value
						if v:FindFirstChild("ActiveTransparency") then
							v.Transparency = v.ActiveTransparency.Value
						end
					end
				elseif v.Name == "DownIND" then
					if direction == -1 or direction == 0 then
						v.Material = "Neon"
						v.BrickColor = v.ActiveColor.Value
						if v:FindFirstChild("ActiveTransparency") then
							v.Transparency = v.ActiveTransparency.Value
						end
					end
				end
			end
			for i,v in pairs(shaft[tostring(floor)]:GetChildren()) do
				if v.Name == "UpIND" then
					if direction == 1 or direction == 0 then
						v.Material = "Neon"
						v.BrickColor = v.ActiveColor.Value
						if v:FindFirstChild("ActiveTransparency") then
							v.Transparency = v.ActiveTransparency.Value
						end
					end
				elseif v.Name == "DownIND" then
					if direction == -1 or direction == 0 then
						v.Material = "Neon"
						v.BrickColor = v.ActiveColor.Value
						if v:FindFirstChild("ActiveTransparency") then
							v.Transparency = v.ActiveTransparency.Value
						end
					end
				end
			end
			--/ Narrator /--
			if cfg.narrator then
				spawn(voiceRoutine)
			end
			--/ Open Doors /--
			if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
				for i,v in pairs(car.FrontDoor:GetChildren()) do
					v.Door.Anchored = true
					tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
						["CFrame"] = v.Open.CFrame,
					}):Play()
				end
				for i,v in pairs(shaft[tostring(floor)].FrontDoor:GetChildren()) do
					tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
						["CFrame"] = v.Open.CFrame,
					}):Play()
				end
			end
			if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
				for i,v in pairs(car.RearDoor:GetChildren()) do
					v.Door.Anchored = true
					tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
						["CFrame"] = v.Open.CFrame,
					}):Play()
				end
				for i,v in pairs(shaft[tostring(floor)].RearDoor:GetChildren()) do
					tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
						["CFrame"] = v.Open.CFrame,
					}):Play()
				end
			end
			--/ Flash Green /--
			for i=1,cfg.doorMoveTime*2.5 do
				if i % 2 == 1 then
					if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
						for i,v in pairs(car.FrontDoor:GetChildren()) do
							if v.Name == "LED" then
								v.Door.BrickColor = BrickColor.new("Lime green")
							end
						end
					end
					if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
						for i,v in pairs(car.RearDoor:GetChildren()) do
							if v.Name == "LED" then
								v.Door.BrickColor = BrickColor.new("Lime green")
							end
						end
					end
				else
					if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
						for i,v in pairs(car.FrontDoor:GetChildren()) do
							if v.Name == "LED" then
								v.Door.BrickColor = BrickColor.new("Really black")
							end
						end
					end
					if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
						for i,v in pairs(car.RearDoor:GetChildren()) do
							if v.Name == "LED" then
								v.Door.BrickColor = BrickColor.new("Really black")
							end
						end
					end
				end
				if not doors then return end
				wait(0.4)
			end
			--/ Solid Green /--
			if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
				for i,v in pairs(car.FrontDoor:GetChildren()) do
					if v.Name == "LED" then
						v.Door.BrickColor = BrickColor.new("Lime green")
					end
				end
			end
			if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
				for i,v in pairs(car.RearDoor:GetChildren()) do
					if v.Name == "LED" then
						v.Door.BrickColor = BrickColor.new("Lime green")
					end
				end
			end
			--/ Door Timer /--
			while (doorTimer > 0 or doorHold) and not (mode == "manual") do
				wait(1)
				doorTimer = doorTimer - 1
			end
			--/ Unlight Lamps /--
			for i,v in pairs(car:GetChildren()) do
				if v.Name == "UpIND" then
					v.Material = "SmoothPlastic"
					v.BrickColor = v.InactiveColor.Value
					if v:FindFirstChild("InactiveTransparency") then
						v.Transparency = v.InactiveTransparency.Value
					end
				elseif v.Name == "DownIND" then
					v.Material = "SmoothPlastic"
					v.BrickColor = v.InactiveColor.Value
					if v:FindFirstChild("InactiveTransparency") then
						v.Transparency = v.InactiveTransparency.Value
					end
				end
			end
			for i,v in pairs(shaft[tostring(floor)]:GetChildren()) do
				if v.Name == "UpIND" then
					v.Material = "SmoothPlastic"
					v.BrickColor = v.InactiveColor.Value
					if v:FindFirstChild("InactiveTransparency") then
						v.Transparency = v.InactiveTransparency.Value
					end
				elseif v.Name == "DownIND" then
					v.Material = "SmoothPlastic"
					v.BrickColor = v.InactiveColor.Value
					if v:FindFirstChild("InactiveTransparency") then
						v.Transparency = v.InactiveTransparency.Value
					end
				end
			end
			--/ Close Doors /--
			doors = false
			if (nudgeCounter > cfg.reopenLimit or (mode ~= "auto" and mode ~= "priority")) and not quickClose then
				if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
					for i,v in pairs(shaft[tostring(floor)].FrontDoor:GetChildren()) do
						tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime*2,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
							["CFrame"] = v.Closed.CFrame,
						}):Play()
					end
					for i,v in pairs(car.FrontDoor:GetChildren()) do
						tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime*2,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
							["CFrame"] = v.Closed.CFrame,
						}):Play()
					end
				end
				if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
					for i,v in pairs(shaft[tostring(floor)].RearDoor:GetChildren()) do
						tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime*2,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
							["CFrame"] = v.Closed.CFrame,
						}):Play()
					end
					for i,v in pairs(car.RearDoor:GetChildren()) do
						tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime*2,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
							["CFrame"] = v.Closed.CFrame,
						}):Play()
					end
				end
			else
				if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
					for i,v in pairs(shaft[tostring(floor)].FrontDoor:GetChildren()) do
						tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
							["CFrame"] = v.Closed.CFrame,
						}):Play()
					end
					for i,v in pairs(car.FrontDoor:GetChildren()) do
						tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
							["CFrame"] = v.Closed.CFrame,
						}):Play()
					end
				end
				if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
					for i,v in pairs(shaft[tostring(floor)].RearDoor:GetChildren()) do
						tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
							["CFrame"] = v.Closed.CFrame,
						}):Play()
					end
					for i,v in pairs(car.RearDoor:GetChildren()) do
						tweenService:Create(v.Door,TweenInfo.new(cfg.doorMoveTime,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
							["CFrame"] = v.Closed.CFrame,
						}):Play()
					end
				end
			end
			--/ Flash Red /--
			if (nudgeCounter > cfg.reopenLimit or (mode ~= "auto" and mode ~= "priority")) and not quickClose then
				for i=1,cfg.doorMoveTime*5 do
					car.Platform.Beep.PlaybackSpeed = 2
					car.Platform.Beep:Play()
					if i % 2 == 1 then
						if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
							for i,v in pairs(car.FrontDoor:GetChildren()) do
								if v.Name == "LED" then
									v.Door.BrickColor = BrickColor.new("Really red")
								end
							end
						end
						if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
							for i,v in pairs(car.RearDoor:GetChildren()) do
								if v.Name == "LED" then
									v.Door.BrickColor = BrickColor.new("Really red")
								end
							end
						end
					else
						if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
							for i,v in pairs(car.FrontDoor:GetChildren()) do
								if v.Name == "LED" then
									v.Door.BrickColor = BrickColor.new("Really black")
								end
							end
						end
						if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
							for i,v in pairs(car.RearDoor:GetChildren()) do
								if v.Name == "LED" then
									v.Door.BrickColor = BrickColor.new("Really black")
								end
							end
						end
					end
					if doors then 
						nudgeCounter = nudgeCounter + 1
						return 
					end
					wait(0.4)
				end
			else
				for i=1,cfg.doorMoveTime*2.5 do
					if i % 2 == 1 then
						if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
							for i,v in pairs(car.FrontDoor:GetChildren()) do
								if v.Name == "LED" then
									v.Door.BrickColor = BrickColor.new("Really red")
								end
							end
						end
						if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
							for i,v in pairs(car.RearDoor:GetChildren()) do
								if v.Name == "LED" then
									v.Door.BrickColor = BrickColor.new("Really red")
								end
							end
						end
					else
						if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
							for i,v in pairs(car.FrontDoor:GetChildren()) do
								if v.Name == "LED" then
									v.Door.BrickColor = BrickColor.new("Really black")
								end
							end
						end
						if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
							for i,v in pairs(car.RearDoor:GetChildren()) do
								if v.Name == "LED" then
									v.Door.BrickColor = BrickColor.new("Really black")
								end
							end
						end
					end
					if doors then 
						nudgeCounter = nudgeCounter + 1
						return 
					end
					wait(0.4)
				end
			end
			--/ Turn Off /--
			if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
				for i,v in pairs(car.FrontDoor:GetChildren()) do
					if v.Name == "LED" then
						v.Door.BrickColor = BrickColor.new("Really black")
					end
				end
			end
			if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
				for i,v in pairs(car.RearDoor:GetChildren()) do
					if v.Name == "LED" then
						v.Door.BrickColor = BrickColor.new("Really black")
					end
				end
			end
			wait((cfg.doorMoveTime*2.5-math.floor(cfg.doorMoveTime*2.5))*0.4)
			if not cfg.cframe then
				if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
					for i,v in pairs(car.FrontDoor:GetChildren()) do
						v.Door.Anchored = false
					end
				end
				if shaft[tostring(floor)]:FindFirstChild("FrontDoor") and car:FindFirstChild("FrontDoor") then
					for i,v in pairs(car.FrontDoor:GetChildren()) do
						v.Door.Anchored = false
					end
				end
				if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
					for i,v in pairs(car.RearDoor:GetChildren()) do
						v.Door.Anchored = false
					end
				end
				if shaft[tostring(floor)]:FindFirstChild("RearDoor") and car:FindFirstChild("RearDoor") then
					for i,v in pairs(car.RearDoor:GetChildren()) do
						v.Door.Anchored = false
					end
				end
			end
			quickClose = false
			doorState = false
			nudgeCounter = 0
		end
		local function forceOpenDoors()
			openDoors(true)
		end
		local function closeDoors()
			doorTimer = 0
		end
		local function toFloor(lvl,override)
			--/ Conditions /--
			if lvl == floor and not override then
				-- We're already on this floor.
				calls[floor] = false
				return false
			end
			if not safety and not override then
				-- Safety is broken.
				return false
			end
			local height = shaft[tostring(lvl)].Level.Position.Y
			travelling = true
			--/ Weld /--
			local weldedPlayers = {}
			local function Weld(a, b)
				local v = Instance.new("ManualWeld")
				v.Part0 = a v.Part1 = b v.C0 = CFrame.new()  v.C1 = b.CFrame:inverse() * a.CFrame
				return v;
			end
			if cfg.weldPlayers then
				for i,v in pairs(car.Sensor:GetTouchingParts()) do
					if v.Name == "HumanoidRootPart" and v.Parent:FindFirstChild("Humanoid") then
						if not v:FindFirstChild("ManualWeld") then
							v.Parent.Humanoid.PlatformStand = true
							--local w = Instance.new("ManualWeld",v)
							--w.Part0 = car.Platform
							--w.Part1 = v
							--w.C0 = car.Platform.CFrame:inverse() * v.CFrame
							Weld(car.Platform,v).Parent = v
							weldedPlayers[#weldedPlayers+1] = v
						end
					end
				end
			end
			local lastAlt = car.Platform.Position.Y
			--/ Cruising /--
			while math.abs((height-car.Platform.Position.Y)/velocity) >= ((math.abs(velocity)/cfg.braking)/10)+(cfg.levelMargin or 0.5) and (mode == "auto" or mode == "fire" or mode == "priority") do
				if height - car.Platform.Position.Y > 0 then
					motor = cfg.maxSpeed
				else
					motor = 0-cfg.maxSpeed
				end
				wait(0)
			end
			--/ Leveling /--
			while math.abs(height-car.Platform.Position.Y) >= cfg.levelTolerance and (mode == "auto" or mode == "fire" or mode == "priority") do
				motor = (height-car.Platform.Position.Y) / (cfg.braking*0.65)
				if math.abs(motor) < cfg.minSpeed then
					if motor > 0 then
						motor = cfg.minSpeed
					else
						motor = 0-cfg.minSpeed
					end
				end
				if motor > cfg.maxSpeed then
					motor = cfg.maxSpeed
				elseif motor < 0-cfg.maxSpeed then
					motor = 0-cfg.maxSpeed
				end
				wait(0)
			end
			--/ Unweld /--
			if cfg.weldPlayers then
				for i,v in pairs(weldedPlayers) do
					if v.Name == "HumanoidRootPart" and v.Parent:FindFirstChild("Humanoid") then
						if v:FindFirstChild("ManualWeld") then
							v.Parent.Humanoid.PlatformStand = false
							v.ManualWeld:Destroy()
						end
					end
				end
			end
			--/ Stop Lift /--
			motor = 0
			velocity = 0
			for i,v in pairs(shaft[tostring(floor)]:GetChildren()) do
				if v.Name == "Call" or v.Name == "UpCall" or v.Name == "DownCall" then
					v.Light.BrickColor = v.InactiveColor.Value
					v.Light.Material = v.InitMaterial.Value
				end
			end
			for _,p in pairs(car:GetChildren()) do
				if p.Name == "Panel" then
					for i,v in pairs(p:GetChildren()) do
						if tonumber(v.Name) == floor then
							v.Light.BrickColor = v.InactiveColor.Value
							v.Light.Material = v.InitMaterial.Value
						end
					end
				end
			end
			wait(0)
			local callsComplete = true
			for i,v in pairs(calls) do
				if v then
					callsComplete = false
				end
			end
			if callsComplete then
				direction = 0
			end
			--/ Open Doors /--
			if mode == "auto" then
				if cfg.idleHold then
					doorHold = true
				end
				spawn(openDoors)
			end
			car.Platform.Velocity = Vector3.new(0,0,0)
			--/ Relevel /--
			if not releveling then
				releveling = true
				while (math.abs(car.Platform.Position.Y-height) > 0 and motor == 0) and (mode == "auto" or mode == "fire" or mode == "priority") do
					local dist = height-car.Platform.Position.Y
					if dist > 0.01 then
						dist = 0.01
					elseif dist < -0.01 then
						dist = -0.01
					end
					car:SetPrimaryPartCFrame(car.Platform.CFrame * CFrame.new(0,dist,0))
					wait()
				end
				releveling = false
			end
			travelling = false
			return true
		end
		local function handleCalls()
			idleTimer = idleTimer + 0.25
			if floor == bottomFloor then
				direction = 1
			elseif floor == topFloor then
				direction = -1
			end
			local nearDist = 4096
			local nearCall = false
			for i,v in pairs(calls) do
				if math.abs(i-floor) < nearDist and v then
					if i == floor then
						-- Call is on current floor. Ignore call
					elseif direction == -1 and i-floor > 0 then
						-- Call is above, direction is down. Ignore call
					elseif direction == 1 and i-floor < 0 then
						-- Call is below, direction is up. Ignore call
					else
						-- Passed all direction checks, we can add it now
						nearDist = math.abs(i-floor)
						nearCall = i
					end
				end
			end
			if nearCall then
				-- Set direction if not set.
				local callsBelow = false
				local callsAbove = false
				for i,v in pairs(calls) do
					if v then
						if i > floor then
							callsAbove = true
						elseif i < floor then
							callsBelow = true
						end
					end
				end
				if not callsAbove then
					if callsBelow then
						direction = -1
					else
						direction = 0
					end
				elseif not callsBelow then
					if callsAbove then
						direction = 1
					else
						direction = 0
					end
				end
				if direction == 0 then
					if nearCall-floor > 0 then
						direction = 1
					elseif nearCall-floor < 0 then
						direction = -1
					end
				end
				if doors and cfg.idleHold and doorHold and mode == "auto" then
					doorHold = false
				end
				if not doors and safety and motor == 0 and not travelling then
					toFloor(nearCall)
					calls[nearCall] = false
				end
			else
				if not doorState and idleTimer > 1 then
					-- Reset direction
					direction = 0
					for i,v in pairs(floorDirs) do
						floorDirs[i] = false
					end
				end
			end
		end
		
		--/ Events /--
		if not ref.Parent:FindFirstChild("DestCall") then
			local val = Instance.new("NumberValue",ref.Parent)
			val.Name = "DestCall"
			val.Value = bottomFloor-1
		end
		if not ref.Parent:FindFirstChild("NextStop") then
			local val = Instance.new("NumberValue",ref.Parent)
			val.Name = "NextStop"
			val.Value = floor
		end
		if not ref.Parent:FindFirstChild("Floor") then
			local val = Instance.new("NumberValue",ref.Parent)
			val.Name = "Floor"
		end
		if not ref.Parent:FindFirstChild("Direction") then
			local val = Instance.new("NumberValue",ref.Parent)
			val.Name = "Direction"
		end
		if not ref.Parent:FindFirstChild("Velocity") then
			local val = Instance.new("NumberValue",ref.Parent)
			val.Name = "Velocity"
		end
		if not ref.Parent:FindFirstChild("Mode") then
			local val = Instance.new("StringValue",ref.Parent)
			val.Name = "Mode"
		end
		ref.Parent.DestCall.Changed:connect(function(val)
			if shaft:FindFirstChild(tostring(val)) then
				ref.Parent.DestCall.Value = bottomFloor-1
				if val == floor and mode == "auto" then 
					openDoors()
				else
					calls[val] = true
				end
			end
		end)
		if car:FindFirstChild("FrontDoor") and cfg.doorSensors then
			for i,v in pairs(car.FrontDoor:GetChildren()) do
				v.Door.Touched:connect(function(obj)
					if obj.Parent:FindFirstChild("Humanoid") and not safety and not doors and doorState and nudgeCounter <= cfg.reopenLimit and mode == "auto" then
						openDoors()
					end
				end)
			end
		end	
		if car:FindFirstChild("RearDoor") and cfg.doorSensors then
			for i,v in pairs(car.RearDoor:GetChildren()) do
				v.Door.Touched:connect(function(obj)
					if obj.Parent:FindFirstChild("Humanoid") and not safety and not doors and doorState and nudgeCounter <= cfg.reopenLimit and mode == "auto" then
						openDoors()
					end
				end)
			end
		end		
		if car:FindFirstChild("FrontDoor") then
			for i,v in pairs(car.FrontDoor:GetChildren()) do
				v.Closed.Touched:connect(function(obj)
					if obj.Name == "HumanoidRootPart" then
						if blacklist[game.Players:GetPlayerFromCharacter(obj.Parent).UserId] then
							if blacklist[game.Players:GetPlayerFromCharacter(obj.Parent).UserId] >= 2 then
								obj.Parent.Humanoid.Health = 0
							end
						end
					end
				end)
			end
		end
		if car:FindFirstChild("RearDoor") then
			for i,v in pairs(car.RearDoor:GetChildren()) do
				v.Closed.Touched:connect(function(obj)
					if obj.Name == "HumanoidRootPart" then
						if blacklist[game.Players:GetPlayerFromCharacter(obj.Parent).UserId] then
							if blacklist[game.Players:GetPlayerFromCharacter(obj.Parent).UserId] >= 2 then
								obj.Parent.Humanoid.Health = 0
							end
						end
					end
				end)
			end
		end
		for _,k in pairs(shaft:GetChildren()) do
			for i,v in pairs(k:GetChildren()) do 
				if v.Name == "Call" or v.Name == "UpCall" or v.Name == "DownCall" then
					local initMat = Instance.new("StringValue",v)
					initMat.Name = "InitMaterial"
					initMat.Value = string.gsub(tostring(v.Light.Material),"Enum.Material.","")
					v.Light.BrickColor = v.InactiveColor.Value
					v.Light.Material = v.InitMaterial.Value
					v.Button.ClickDetector.MouseClick:connect(function()
						if v.Button:FindFirstChild("Sound") then
							v.Button.Sound:Play()
						elseif car.Platform:FindFirstChild("Button") then
							car.Platform.Button:Play()
						end
						v.Light.BrickColor = v.ActiveColor.Value
						v.Light.Material = "Neon"
						if v.Name == "UpCall" and not floorDirs[tonumber(k.Name)] then
							floorDirs[tonumber(k.Name)] = 1
						elseif v.Name == "DownCall" and not floorDirs[tonumber(k.Name)] then
							floorDirs[tonumber(k.Name)] = -1
						end
						if direction == 0 and floor == tonumber(k.Name) then
							if v.Name == "UpCall" then
								direction = 1
							elseif v.Name == "DownCall" then
								direction = -1
							end
						end
						if tonumber(k.Name) ~= floor then
							calls[tonumber(k.Name)] = true
						elseif not doors and motor == 0 and mode == "auto" then
							wait(0.1)
							v.Light.BrickColor = v.InactiveColor.Value
							v.Light.Material = v.InitMaterial.Value
							openDoors()
						else
							wait(0.1)
							v.Light.BrickColor = v.InactiveColor.Value
							v.Light.Material = v.InitMaterial.Value
						end
					end)
				end
			end
		end
		for _,p in pairs(car:GetChildren()) do
			if p.Name == "Panel" then
				for i,v in pairs(p:GetChildren()) do
					if shaft:FindFirstChild(v.Name) then
						local initMat = Instance.new("StringValue",v)
						initMat.Name = "InitMaterial"
						initMat.Value = string.gsub(tostring(v.Light.Material),"Enum.Material.","")
						v.Light.BrickColor = v.InactiveColor.Value
						v.Light.Material = v.InitMaterial.Value
						v.Button.ClickDetector.MouseClick:connect(function()
							if car.Platform:FindFirstChild("Button") then
								car.Platform.Button:Play()
							end
							if mode == "priority" then
								if safety and motor == 0 and tonumber(v.Name) ~= floor then
									for _,k in pairs(car:GetChildren()) do
										if k.Name == "Panel" then
											for _,z in pairs(k:GetChildren()) do
												if z.Name == v.Name then
													z.Light.BrickColor = z.ActiveColor.Value
													z.Light.Material = "Neon"
												end
											end
										end
									end
									toFloor(tonumber(v.Name))
								end
								return
							end
							for _,z in pairs(car:GetChildren()) do
								if z.Name == "Panel" then
									for _,k in pairs(z:GetChildren()) do
										if k.Name == v.Name then
											k.Light.BrickColor = k.ActiveColor.Value
											k.Light.Material = "Neon"
										end
									end
								end
							end
							if floor ~= tonumber(v.Name) then
								calls[tonumber(v.Name)] = true
							elseif not doors and not calls[floor] and motor == 0 and mode == "auto" then
								wait(0.1)
								for _,z in pairs(car:GetChildren()) do
									if z.Name == "Panel" then
										for _,k in pairs(z:GetChildren()) do
											if k.Name == v.Name then
												k.Light.BrickColor = k.InactiveColor.Value
												k.Light.Material = k.InitMaterial.Value
											end
										end
									end
								end
								if mode == "auto" and motor == 0 then
									openDoors()
								end
							else
								wait(0.1)
								for _,z in pairs(car:GetChildren()) do
									if z.Name == "Panel" then
										for _,k in pairs(z:GetChildren()) do
											if k.Name == v.Name then
												k.Light.BrickColor = k.InactiveColor.Value
												k.Light.Material = k.InitMaterial.Value
											end
										end
									end
								end
							end
						end)
					elseif v.Name == "Open" then
						local initMat = Instance.new("StringValue",v)
						initMat.Name = "InitMaterial"
						initMat.Value = string.gsub(tostring(v.Light.Material),"Enum.Material.","")
						v.Light.BrickColor = v.InactiveColor.Value
						v.Light.Material = v.InitMaterial.Value
						v.Button.ClickDetector.MouseClick:connect(function()
							if mode == "priority" and motor == 0 then
								doorHold = true
							end
							if #inputs < 24 then
								inputs = inputs .. "O"
							end
							if car.Platform:FindFirstChild("Button") then
								car.Platform.Button:Play()
							end
							for _,z in pairs(car:GetChildren()) do
								if z.Name == "Panel" then
									for _,k in pairs(z:GetChildren()) do
										if k.Name == v.Name then
											k.Light.BrickColor = k.ActiveColor.Value
											k.Light.Material = "Neon"
										end
									end
								end
							end
							if not doors and motor == 0 and mode == "auto" then
								wait(0.1)
								for _,z in pairs(car:GetChildren()) do
									if z.Name == "Panel" then
										for _,k in pairs(z:GetChildren()) do
											if k.Name == v.Name then
												k.Light.BrickColor = k.InactiveColor.Value
												k.Light.Material = k.InitMaterial.Value
											end
										end
									end
								end
								openDoors()
							else
								wait(0.1)
								for _,z in pairs(car:GetChildren()) do
									if z.Name == "Panel" then
										for _,k in pairs(z:GetChildren()) do
											if k.Name == v.Name then
												k.Light.BrickColor = k.InactiveColor.Value
												v.Light.Material = v.InitMaterial.Value
											end
										end
									end
								end
							end
							if mode == "priority" and motor == 0 then
								openDoors(true)
							end
						end)
					elseif v.Name == "Close" then
						local initMat = Instance.new("StringValue",v)
						initMat.Name = "InitMaterial"
						initMat.Value = string.gsub(tostring(v.Light.Material),"Enum.Material.","")
						v.Light.BrickColor = v.InactiveColor.Value
						v.Light.Material = v.InitMaterial.Value
						v.Button.ClickDetector.MouseClick:connect(function()
							if mode == "priority" then
								doorHold = false
							end
							if #inputs < 24 then
								inputs = inputs .. "X"
							end
							if car.Platform:FindFirstChild("Button") then
								car.Platform.Button:Play()
							end
							for _,z in pairs(car:GetChildren()) do
								if z.Name == "Panel" then
									for _,k in pairs(z:GetChildren()) do
										if k.Name == v.Name then
											k.Light.BrickColor = k.ActiveColor.Value
											v.Light.Material = "Neon"
										end
									end
								end
							end
							wait(0.1)
							for _,z in pairs(car:GetChildren()) do
								if z.Name == "Panel" then
									for _,k in pairs(z:GetChildren()) do
										if k.Name == v.Name then
											k.Light.BrickColor = k.InactiveColor.Value
											k.Light.Material = k.InitMaterial.Value
										end
									end
								end
							end
							doorTimer = 0
						end)
					elseif v.Name == "Screen" then
						screens[#screens+1] = v
					elseif v.Name == "Alarm" then
						local initMat = Instance.new("StringValue",v)
						initMat.Name = "InitMaterial"
						initMat.Value = string.gsub(tostring(v.Light.Material),"Enum.Material.","")
						v.Light.BrickColor = v.InactiveColor.Value
						v.Light.Material = v.InitMaterial.Value
						v.Button.ClickDetector.MouseClick:connect(function()
							if sequences[inputs] then
								sequences[inputs]()
							end
							inputs = ""
							if car.Platform:FindFirstChild("Button") then
								car.Platform.Button:Play()
							end
							if car.Platform.Beep.IsPlaying then
								return
							end
							-- Sound Alarm
							if car.Platform:FindFirstChild("Alarm") then
								car.Platform.Alarm:Play()	
							end
							for i=1,8 do
								if not car.Platform:FindFirstChild("Alarm") then
									car.Platform.Beep.PlaybackSpeed = 1.5
									car.Platform.Beep:Play()
								end
								
								for _,z in pairs(car:GetChildren()) do
									if z.Name == "Panel" then
										for _,k in pairs(z:GetChildren()) do
											if k.Name == v.Name then
												k.Light.BrickColor = k.ActiveColor.Value
												v.Light.Material = "Neon"
											end
										end
									end
								end
								wait(0.2)
								if not car.Platform:FindFirstChild("Alarm") then
									car.Platform.Beep.PlaybackSpeed = 2
									car.Platform.Beep:Play()
								end
								for _,z in pairs(car:GetChildren()) do
									if z.Name == "Panel" then
										for _,k in pairs(z:GetChildren()) do
											if k.Name == v.Name then
												k.Light.BrickColor = k.InactiveColor.Value
												k.Light.Material = k.InitMaterial.Value
											end
										end
									end
								end
								wait(0.2)
							end
						end)
					end
				end
			end
		end
		if car:FindFirstChild("Controls") then
			car.Controls.Switch.ClickDetector.MouseClick:connect(function()
				if mode ~= "manual" then
					car.Controls.Switch.Transparency = 1
					car.Controls.SwitchTurned.Transparency = 0
					inService = false
					mode = "manual"
					if cfg.narrator then
						voice.TimePosition = 19.55
						voice:Play()
					end
				elseif mode == "manual" then
					car.Controls.Switch.Transparency = 0
					car.Controls.SwitchTurned.Transparency = 1
					inService = true
					mode = "auto"
					toFloor(floor,true)
				end
				motor = 0
			end)
			car.Controls.Up.SurfaceGui.Button.MouseButton1Down:connect(function()
				if mode == "manual" then
					motor = cfg.insSpeed
				end
			end)
			car.Controls.Up.SurfaceGui.Button.MouseButton1Up:connect(function()
				if mode == "manual" then
					motor = 0
				end
			end)
			car.Controls.Down.SurfaceGui.Button.MouseButton1Down:connect(function()
				if mode == "manual" then
					motor = 0-cfg.insSpeed
				end
			end)
			car.Controls.Down.SurfaceGui.Button.MouseButton1Up:connect(function()
				if mode == "manual" then
					motor = 0
				end
			end)
			car.Controls.Stop.ClickDetector.MouseClick:connect(function()
				emergencyStop = not emergencyStop
				if not emergencyStop then
					car.Controls.Stop.Transparency = 0
					if car.Controls.Stop:FindFirstChild("SurfaceGui") then
						car.Controls.Stop.SurfaceGui.Enabled = true
					end
					car.Controls.StopPressed.Transparency = 1
					if car.Controls.StopPressed:FindFirstChild("SurfaceGui") then
						car.Controls.StopPressed.SurfaceGui.Enabled = false
					end
				else
					car.Controls.Stop.Transparency = 1
					if car.Controls.Stop:FindFirstChild("SurfaceGui") then
						car.Controls.Stop.SurfaceGui.Enabled = false
					end
					car.Controls.StopPressed.Transparency = 0
					if car.Controls.StopPressed:FindFirstChild("SurfaceGui") then
						car.Controls.StopPressed.SurfaceGui.Enabled = true
					end
				end
			end)
		end
		local api = Instance.new("BindableFunction",ref.Parent)
		api.Name = "API"
		function api.OnInvoke(call,param)
			if call == "fireRecall" then
				if param == true and mode == "fire" then
					return false
				elseif param == false and mode ~= "fire" then
					return false
				end
				if mode ~= "manual" then
					if param then
						if floor == (cfg.recallFloor or bottomFloor) and motor == 0 then
							inService = false
							mode = "fire"
							doorHold = true
							openDoors()								
						else
							inService = false
							doorHold = false
							mode = "manual"
							wait(0.1)
							mode = "fire"
							repeat
								wait(0.1)
							until not doorState
							wait(0.1)
							nudgeCounter = 0
							repeat
								wait(0.1)
							until toFloor(cfg.recallFloor or bottomFloor,true)
							doorHold = true
							repeat
								spawn(forceOpenDoors)
								wait(0.1)
							until doors
						end
					else
						inService = true
						doorHold = false
						mode = "auto"
					end
					return true
				else
					return false
				end
			elseif call == "doorHold" then
				doorHold = param
				return true
			elseif call == "independent" then
				if mode == "priority" and param == false then
					mode = "auto"
					inService = true
					doorHold = false
					return true
				elseif mode ~= "manual" and param == true then
					mode = "priority"
					inService = false
					return true
				else
					return false
				end
			elseif call == "doorOpen" then
				if motor == 0 then
					spawn(forceOpenDoors)
				end
			elseif call == "doorClose" then
				quickClose = true
				doorHold = false
				nudgeCounter = cfg.reopenLimit + 1
				doorTimer = 0
			elseif call == "initialSafety" then
				initialSafety = param
			elseif call == "getDoorTarget" then
				return doors
			elseif call == "setDirection" then
				direction = param
			elseif call == "callCancel" then
				inService = false
				local lastMode = mode
				mode = "manual"
				wait(0.1)
				mode = lastMode
				inService = true
			end
		end
		
		--/ Routines /--
		if cfg.idleHold then
			doorHold = true
			spawn(openDoors)
		end
		spawn(function()
			while true do
				--/ Check Safety /--
				safety = (not doorState) and (not emergencyStop) and initialSafety 
				for i,v in pairs(shaft:GetChildren()) do
					if v:FindFirstChild("FrontDoor") then
						for i,v in pairs(v.FrontDoor:GetChildren()) do
							if v.Door.CFrame ~= v.Closed.CFrame then
								safety = false
							end
						end
					end
					if v:FindFirstChild("RearDoor") then
						for i,v in pairs(v.RearDoor:GetChildren()) do
							if v.Door.CFrame ~= v.Closed.CFrame then
								safety = false
							end
						end
					end
				end
				if car:FindFirstChild("FrontDoor") then
					for i,v in pairs(car.FrontDoor:GetChildren()) do
						if v.Door.CFrame ~= v.Closed.CFrame then
							safety = false
						end
					end
				end
				if car:FindFirstChild("RearDoor") then
					for i,v in pairs(car.RearDoor:GetChildren()) do
						if v.Door.CFrame ~= v.Closed.CFrame then
							safety = false
						end
					end
				end
				--/ Motor Speed Controller /--
				if car.Platform.Position.Y > shaft[tostring(topFloor)].Level.Position.Y and (velocity > 0 or motor > 0) then
					motor = 0
					velocity = 0
				elseif car.Platform.Position.Y < shaft[tostring(bottomFloor)].Level.Position.Y and (velocity < 0 or motor < 0) then
					motor = 0	
					velocity = 0			
				end
				if not safety then
					motor = 0
					velocity = 0
				else
					if motor > 0 then
						if velocity > motor then
							velocity = velocity - cfg.braking
							if math.abs(motor-velocity) <= cfg.braking then
								velocity = motor
							end
						elseif velocity < motor then
							velocity = velocity + cfg.acceleration
							if math.abs(motor-velocity) <= cfg.acceleration then
								velocity = motor
							end
						end
					elseif motor == 0 then
						if velocity > motor then
							velocity = velocity - cfg.braking
							if math.abs(motor-velocity) <= cfg.braking then
								velocity = motor
							end
						elseif velocity < motor then
							velocity = velocity + cfg.braking
							if math.abs(motor-velocity) <= cfg.braking then
								velocity = motor
							end
						end
					elseif motor < 0 then
						if velocity > motor then
							velocity = velocity - cfg.acceleration
							if math.abs(motor-velocity) <= cfg.acceleration then
								velocity = motor
							end
						elseif velocity < motor then
							velocity = velocity + cfg.braking
							if math.abs(motor-velocity) <= cfg.braking then
								velocity = motor
							end
						end
					end
				end
				if not cfg.cframe then
					if velocity == 0 then
						if not car.Platform.Anchored then
							car.Platform.Anchored = true
							for i,v in pairs(car:GetChildren()) do
								if v.ClassName == "Part" or v.ClassName == "WedgePart" or v.ClassName == "MeshPart" or v.ClassName == "CornerWedgePart" or v.ClassName == "UnionOperation" or v.ClassName == "TrussPart" or v.ClassName == "Seat" then
									v.Velocity = Vector3.new(0,0,0)
									v.RotVelocity = Vector3.new(0,0,0)
								end
							end
						end
					else
						if car.Platform.Anchored then
							car.Platform.Anchored = false
						end
					end
					bodyvelocity.Velocity = Vector3.new(0,velocity,0)
				end
				ref.Parent.Velocity.Value = velocity
				--/ Motor Noise Generator /--
				if math.abs(velocity) > (cfg.motorCutoff or 0) and (motorMode == "idle" or motorMode == "stop") then
					motorMode = "start"
					car.Platform.Start:Play()
				elseif motorMode == "start" and car.Platform.Start.IsPlaying == false then
					motorMode = "run"
					car.Platform.Run:Play()
				elseif math.abs(velocity) <= (cfg.motorCutoff or 0) and (motorMode == "run" or motorMode == "start") then
					motorMode = "stop"
					car.Platform.Start:Stop()
					car.Platform.Run:Stop()
					car.Platform.Stop:Play()
				elseif math.abs(velocity) <= 0 and motorMode == "stop" then
					motorMode = "idle"
				end
				--/ Locate Car /--
				local nearDist = 32768
				local nearFloor = 0
				for i,v in pairs(shaft:GetChildren()) do
					if math.abs(v.Level.Position.Y-car.Platform.Position.Y) <= nearDist then
						nearDist = math.abs(v.Level.Position.Y-car.Platform.Position.Y)
						nearFloor = tonumber(v.Name)
					end
				end
				if nearFloor ~= floor then
					car.Platform.Beep.PlaybackSpeed = 1
					car.Platform.Beep:Play()
				end
				floor = nearFloor
				ref.Parent.Floor.Value = floor
				for i,v in pairs(screens) do
					if motor == 0 then
						v.SurfaceGui.Floor.Position = UDim2.new(0.125,0,0,0)
					else
						v.SurfaceGui.Floor.Position = UDim2.new(0.25,0,0,0)
					end
					if motor > 0 then
						v.SurfaceGui.Direction.Text = cfg.upIndicator or "-->"
					elseif motor < 0 then
						v.SurfaceGui.Direction.Text = cfg.downIndicator or "<--"
					else
						v.SurfaceGui.Direction.Text = ""
					end
					v.SurfaceGui.Floor.Text = tostring(floor)
				end
				for i,v in pairs(shaft:GetChildren()) do
					if v:FindFirstChild("FloorIND") then
						v.FloorIND.SurfaceGui.Floor.Text = floor
					end
				end
				for _,v in pairs(car:GetChildren()) do
					if v.Name == "DestPanel" then
						for _,l in pairs(v.SurfaceGui:GetChildren()) do
							if tonumber(l.Name) then
								if calls[tonumber(l.Name)] then
									l.TextTransparency = 0
								else
									l.TextTransparency = 1
								end
							end
						end
					end
				end
				--/ Call Management /--
				if (not doors or cfg.idleHold) and motor == 0 and mode == "auto" then
					spawn(handleCalls)
					if floor == bottomFloor then
						direction = 1
					elseif floor == topFloor then
						direction = -1
					end
				end
				if not inService then
					if mode ~= "priority" then
						for _,p in pairs(car:GetChildren()) do
							if p.Name == "Panel" then
								for i,v in pairs(p:GetChildren()) do
									if tonumber(v.Name) then
										v.Light.BrickColor = v.InactiveColor.Value
										if v:FindFirstChild("InitMaterial") then
											v.Light.Material = v.InitMaterial.Value
										end
									end
								end
							end
						end
					end
					for _,f in pairs(shaft:GetChildren()) do
						for i,v in pairs(f:GetChildren()) do
							if v.Name == "Call" or v.Name == "UpCall" or v.Name == "DownCall" then
								v.Light.BrickColor = v.InactiveColor.Value
								if v:FindFirstChild("InitMaterial") then
									v.Light.Material = v.InitMaterial.Value
								end
							end
						end
					end
					for i,v in pairs(calls) do
						calls[i] = false
					end
				end
				ref.Parent.Direction.Value = direction
				--/ Inspection Controls /--
				ref.Parent.Mode.Value = mode
				if car:FindFirstChild("Controls") then
					car.Controls.Display.SurfaceGui.Label.Text = string.upper(mode)
				end
				if velocity == 0 then
					wait(0.25)
				else
					wait(0.05)
					idleTimer = 0
				end
				if cfg.parkingFloor then
					if idleTimer > (cfg.parkingTimer or 20) and floor ~= cfg.parkingFloor then
						calls[cfg.parkingFloor] = true
					end
				end
			end
		end)
		runService.Heartbeat:connect(function(cycle)
			if cfg.cframe then
				car:SetPrimaryPartCFrame(car.Platform.CFrame * CFrame.new(0,cycle*velocity,0))
			end
			if ref.Parent:FindFirstChild("Weight") then
				if cfg.cframe then
					ref.Parent.Weight:SetPrimaryPartCFrame(ref.Parent.Weight.Platform.CFrame * CFrame.new(0,0-cycle*velocity,0))
				else
					for i,v in pairs(ref.Parent.Motor.Pulley:GetChildren()) do
						if v.Name == "Rope" then
							v.Length = (car.Platform.Position.Y - shaft[tostring(bottomFloor)].Level.Position.Y) + cfg.cwOffset
						end
					end			
					if car:FindFirstChild("Hoist") then
						for i,v in pairs(car.Hoist:GetChildren()) do
							if v.Name == "Cable" then
								local dist = ref.Parent.Motor.Motor.Anchor.Position.Y - v.Position.Y
								v.Mesh.Scale = Vector3.new(dist*4,1,1)
								v.Mesh.Offset = Vector3.new(dist/2,0,0)
							end
						end
					end	
				end
			end
			if cfg.weldPlayers and cfg.cframe then
				for i,v in pairs(car.Sensor:GetTouchingParts()) do
					if v.Name == "Torso" and v:FindFirstChild("ManualWeld") then
						v.CFrame = v.CFrame * CFrame.new(0,cycle*velocity,0)
					end
				end
			end
		end)
		if not cfg.cframe then
			--car.Platform.Anchored = false
			pcall(function()
				car.Platform:SetNetworkOwner()
			end)
		end
	end
}

return module