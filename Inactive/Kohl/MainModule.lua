--|   __________   |--
--|  |Core Setup|  |--
--|   ����������   |--
script.Parent=nil
local f,new={s=script;},function(a,b) return function(d) local c=Instance.new(a) for i,v in next,d do if type(i)=='number' then v.Parent=c else c[i]=v end end c.Parent=c.Parent or b return c end end
local S,s,FindChild,WaitForChild,wrap=function(a) return game:GetService(a) end, nil
FindChild=function(a,b,c,d,e)d,e=pcall(function() return a[b] end) if d then return e end if c then for _,d in next,a:children() do c=FindChild(d,b,true) if c then return c end end end return nil end
WaitForChild=function(a,b,c) repeat c=FindChild(a,b) wait() until c return c end
wrap=function(a,...) return coroutine.resume(coroutine.create(a),...) end wrap(function() workspace.AllowThirdPartySales=true end)
s={Teams=S'Teams';Debris=S'Debris';DataStore=S'DataStoreService';Market=S'MarketplaceService';
NetServer=S'NetworkServer';TP=S'TeleportService';workspace=S'Workspace';Content=S'ContentProvider';
Players=S'Players';Lighting=S'Lighting';Badge=S'BadgeService';Run=S'RunService';Group=S'GroupService';
RFirst=S'ReplicatedFirst';RStorage=S'ReplicatedStorage';SStorage=S'ServerStorage';Insert=S'InsertService';
StarterGui=S'StarterGui';StarterPack=S'StarterPack';StarterPlayer=S'StarterPlayer';
SSS=S'ServerScriptService';SS=S'SoundService';HTTP=S'HttpService';
Commands={};Logs={};ChatLogs={};Votes={},LastVote=0} s.SPS=s.StarterPlayer.StarterPlayerScripts
local v3,v2,u2,cf,cfa,mrad,mdeg,mran,mabs,mflr,mcel,min,max,c3,bc=Vector3.new,Vector2.new,UDim2.new,CFrame.new,CFrame.Angles,math.rad,math.deg,math.random,math.abs,math.floor,math.ceil,math.min,math.max,Color3.new,BrickColor.new
local NR,NS,NSK,CS,CSK=NumberRange.new,NumberSequence.new,NumberSequenceKeypoint.new,ColorSequence.new,ColorSequenceKeypoint.new

local _D,Client,SuperCrown,Shine=script.D:Clone() SuperCrown,Shine=_D.SuperCrown:Clone(),new'Attachment'{Name='KShine'} _D.Shine:Clone().Parent=Shine Client=_D.Client Client.Name='\n\a\n' Client.Disabled,Client.Archivable=false,false while FindChild(s.RFirst,'\n\a\n') do s.RFirst['\n\a\n']:Destroy() end Client.Parent=s.RFirst _D.Chat.Parent=s.RFirst Client.Changed:connect(function() if Client.Parent~=s.RFirst then Client.Parent=s.RFirst end end)
local DS,SN=pcall(function() return s.DataStore:GetGlobalDataStore() end) and s.DataStore:GetGlobalDataStore() or nil,'Kohl\'s Admin Infinite'
local NameCache,Admins,Bans,Set,StudioSet={},{},{},{},{Color=c3();ColorTransparency=.8;AdminCredit=true;AutoCleanDelay=30;CommandBar=true;FunCommands=true;Prefix=':';GroupAdmin={};VIPAdmin={};Permissions={};}
local LocalSet,ClearObjects,olite={SLock=false},{},{} olite.Ambient,olite.Brightness,olite.OutdoorAmbient,olite.ShadowColor,olite.TimeOfDay,olite.FogColor,olite.FogEnd,olite.FogStart=s.Lighting.Ambient,s.Lighting.Brightness,s.Lighting.OutdoorAmbient,s.Lighting.ShadowColor,s.Lighting.TimeOfDay,s.Lighting.FogColor,s.Lighting.FogEnd,s.Lighting.FogStart
local server,admstr,banstr,logb,clogb,fs=FindChild(s.RStorage,'b\a\n\a\n\a'),new'StringValue'{Name='\a\d\m\i\n'},new'StringValue'{Name='\b\a\n'},new'BoolValue'{Name='\l\o\g'},new'BoolValue'{Name='\c\l\o\g'},('%c'):rep(7):format(83,99,114,105,112,116,104) if server then server:Destroy() end server=new'RemoteEvent'{Parent=s.RStorage;Name='b\a\n\a\n\a';Archivable=false} admstr.Parent,banstr.Parent,logb.Parent,clogb.Parent=server,server,server,server
local SETTINGS,CUSTOM=WaitForChild(s.SSS,SN) if SETTINGS:IsA'Model' then SETTINGS:Destroy() SETTINGS=WaitForChild(s.SSS,SN) end if not SETTINGS then script:Destroy() end CUSTOM,SETTINGS=FindChild(SETTINGS,'Custom Commands'),FindChild(SETTINGS,'Settings') if not (SETTINGS and CUSTOM) then script:Destroy() end local b,e=wrap(function() CUSTOM=require(CUSTOM) end) if not b then print(SN..' Custom Command Error:\t'..e) CUSTOM={} end SETTINGS=require(SETTINGS) StudioSet=SETTINGS[1] for i,v in next,StudioSet do Set[i]=v end Set.FreeAdmin=Set.FreeAdmin and min(5,max(Set.FreeAdmin,0))
local Closing,Closed,SaveData,SaveLogs=false,false,false,false
local creatorId=game.CreatorType==Enum.CreatorType.Group and FindChild(s.Group:GetGroupInfoAsync(game.CreatorId).Owner,'Id') or game.CreatorId Admins[creatorId]=6

local TextService = game:GetService("TextService")

local function getTextObject(message, fromPlayerId)
	local textObject
	local success, errorMessage = pcall(function()
		textObject = TextService:FilterStringAsync(message, fromPlayerId)
	end)
	if success then
		return textObject
	elseif errorMessage then
		print("Error generating TextFilterResult:", errorMessage)
	end
	return false
end

local function getFilteredMessage(textObject, toPlayerId)
	local filteredMessage
	local success, errorMessage = pcall(function()
		filteredMessage = toPlayerId and textObject:GetChatForUserAsync(toPlayerId) or textObject:GetNonChatStringForBroadcastAsync()
	end)
	if success then
		return filteredMessage
	elseif errorMessage then
		print("Error filtering message:", errorMessage)
	end
	return ""
end

--|  Server Functions  |--
--|  ����������������  |--
f.AssetInfo=function(a) return s.Market:GetProductInfo(a) end
f.Merge=function(a,b) for i,v in next,b do a[i]=v end return a end
f.CheckLogs=function(a,b) for i,v in next,a do if v[1]==b[1] and v[2]==b[2] then return false end end return true end
f.LMerge=function(a,b,c)c={} for i,v in next,a do c[i]=v end for i,v in next,b do if f.CheckLogs(a,v) then table.insert(c,v) end end return c end
f.ClearTab=function(a,b) for i,v in next,b do a[i]=nil end return a end
f.MapTab=function(a,b)b={} for i,v in next,a do if type(v)=='table' then b[tostring(i)]=f.MapTab(v) else b[tostring(i)]=v end end return b end
f.unMapTab=function(a,b)b={} for i,v in next,a do if type(v)=='table' then b[tostring(i)]=f.unMapTab(v) else b[tonumber(i)]=v end end return b end
f.AdminS=function(a,b)b='' for i,v in next,a do b=b..' '..i..':'..v end return b end
f.Cache=function(a,b)b='' for i,v in next,a do if v<0 and v>-6 then b=b..' '..i..':'..v end end return b end
f.unCache=function(a,b,c,d)b={} for i in a:gmatch('%S+') do c,d=i:match('(.+):(.+)') if tonumber(d)>-6 then b[tonumber(c)]=tonumber(d) end end return b end
f.SortLogs=function(a,b)a,b=a or {},{} table.sort(a,function(a,b) return a[1]>b[1] end) for i=1,min(#a,300) do b[i]=a[i] end return b end
f.KUpdateLog=function(a) server:FireAllClients('KUpdateLog',a) end
f.KUpdateCLog=function(a) server:FireAllClients('KUpdateCLog',a) end
f.KUpdateLogs=function() server:FireAllClients('KUpdateLogs',s.Logs) end
f.KUpdateCLogs=function() server:FireAllClients('KUpdateCLogs',s.ChatLogs) end
f.SetAdmins=function(a)a={} for i,v in next,Admins do if v>0 then a[i]=v end end return a end
f.SetBans=function(a)a={} for i,v in next,Bans do if v>0 then a[i]=v end end return a end
f.Players=function(a)a={} if s.NetworkServer then for i,v in next,s.NetworkServer:children() do if v:GetPlayer() then a[#a+1]=v:GetPlayer() end end elseif s.Players then a=s.Players:GetPlayers() end return a end
f.getPlayer=function(a,b)b={nil} for i,v in next,f.Players() do if v and v.Name:lower()==a then b={v,true} end end if not b[2] then for i,v in next,f.Players() do if v and FindChild(v,'KNick') and v.KNick.Value:lower()==a then b={v,true} end end end if not b[2] then for i,v in next,f.Players() do if v.Name:lower():find(a)==1 or (FindChild(v,'KNick') and v.KNick.Value:lower():find(a)==1) then b={v} end end end return b[1] end
f.toPlayer=function(a,b,c,id)id=c if not b then return end c={} b=b:lower() local pow=f.getPower(a)
if not b:match'%S' or (pow<2 and a.userId~=game.VIPServerOwnerId) then c={a} elseif b=='all' then c=f.Players() else
for d in b:gmatch'[^,]+' do
local plr=f.getPlayer(d)
if d=='me' then c[#c+1]=a
elseif d=='random' then c[#c+1]=f.Players()[mran(#f.Players())]
elseif d=='others' then for i,v in next,f.Players() do if v~=a then c[#c+1]=v end end
elseif d=='friends' then for i,v in next,f.Players() do if v~=a and v:IsFriendsWith(a.userId) then c[#c+1]=v end end
elseif d=='guests' then for i,v in next,f.Players() do if v.Name:sub(1,6)=='Guest ' then c[#c+1]=v end end
elseif d=='vets' or d=='veterans' then for i,v in next,f.Players() do if v.AccountAge>364 then c[#c+1]=v end end
elseif d=='alts' or d=='noobs' then for i,v in next,f.Players() do if v.AccountAge<365 then c[#c+1]=v end end
elseif d=='close' then for i,v in next,f.Players() do if v and v.Character and a.Character and (v.Character:GetPrimaryPartCFrame().p-a.Character:GetPrimaryPartCFrame().p).magnitude<=50 then c[#c+1]=v end end
elseif d=='far' then for i,v in next,f.Players() do if v and v.Character and a.Character and (v.Character:GetPrimaryPartCFrame().p-a.Character:GetPrimaryPartCFrame().p).magnitude>50 then c[#c+1]=v end end
elseif d:find'rad'==1 and d:match'%d+$' and d:match'%d+$'~=d then local r=tonumber(d:match'%d+$') for i,v in next,f.Players() do if v and v.Character and a.Character and (v.Character:GetPrimaryPartCFrame().p-a.Character:GetPrimaryPartCFrame().p).magnitude<=r then c[#c+1]=v end end
elseif d:find'g'==1 and d:match'%d+$' and d:match'%d+$'~=d then local gp=tonumber(d:match'%d+$') for i,v in next,f.Players() do if v:IsInGroup(gp) then c[#c+1]=v end end
elseif d:find'[t%%]'==1 and d:match'%w+$' and d:match'%w+$'~=d then local t=d:match'%w+$' local tc for i,v in next,s.Teams:children() do if v.Name:lower():find(t)==1 then tc=v.TeamColor break end end for i,v in next,f.Players() do if v and v.TeamColor==tc then c[#c+1]=v end end
elseif d:find'#'==1 and d:match('%d+',2) then local n,P=tonumber(d:match('%d+',2)),{} for i,v in next,f.Players() do P[#P+1]=v end for i=1,min(#P,n) do i=mcel(mran(#P)) c[#c+1]=P[i] table.remove(P,i) end
elseif d=='admins' then for i,v in next,f.Players() do if mabs(Admins[v.userId] or 0)>1 then c[#c+1]=v end end
elseif d=='nonadmins' then for i,v in next,f.Players() do if mabs(Admins[v.userId] or 0)<2 then c[#c+1]=v end end
elseif plr then c[#c+1]=plr
elseif id and tonumber(d) and wrap(f.getNameFromId,tonumber(d)) then c[#c+1]=tonumber(d)
end
end
end if id then for i,v in next,c do c[i]=tonumber(v) or v.userId end end
return c
end
f.CastRay=function(a,b,c) local vec=b-a return workspace:FindPartOnRayWithIgnoreList(Ray.new(a,vec.unit*min(vec.magnitude,999)),c or {},false,true) end
f.MatchClr=function(a,b)a=a or '' b=bc(a:sub(1,1):upper()..a:sub(2)) b=b~=bc'' and b or nil if not b then for i,v in next,{'New Yeller','Pastel Blue','Dusty Rose','CGA brown'} do if a:lower():find('^'..v) then b=bc(v) end end end if not b and a:find'^random' then b=BrickColor.Random() end b=b and b.Color return b end
f.Crash=function(a) server:FireClient(a,'KCrash') end
f.Kick=function(a,b)b=b or 'Kicked' if not wrap(function() a:Kick(b) end) then f.Crash(a) end end
f.setBan=function(a,b,c,d)b=b or 0 if type(a)=='string' then c,d=pcall(function() return s.Players:GetUserIdFromNameAsync(a) end) if not (c and d) then return end a=d end if b==0 then Bans[a]=nil else Bans[a]=b end banstr.Value=f.AdminS(Bans) if b<1 then SaveData=0 end end
f.setPower=function(a,b,c,d) b=b or 0 if type(a)=='string' then c,d=pcall(function() return s.Players:GetUserIdFromNameAsync(a) end) if not (c and d) then return end a=d end if b==0 then Admins[a]=nil else Admins[a]=max(-6,min(b,6)) end admstr.Value=f.AdminS(Admins) if b<1 then SaveData=0 end end
f.getPower=function(a,b)a=tonumber(a) or FindChild(a,'userId') return Admins[a] and mabs(Admins[a])>(Set.FreeAdmin or 0) and mabs(Admins[a]) or (Set.FreeAdmin or 0) end
f.getTitle=function(a)a=tonumber(a) or f.getPower(a) return a==6 and 'Game Creator' or a==5 and 'Owner' or a==4 and 'Super Admin' or a==3 and 'Administrator' or a==2 and 'Moderator' or a==1 and 'VIP' or 'Player' end
f.getMass=function(a,b)b=b or 0 for i,v in next,a:children() do if v:IsA'BasePart' then b=b+v:GetMass() end f.getMass(v) end return b end
f.getTime=function(t,s)t=t%86400 s={t%60,t%3600/60,t/3600} for i,v in next,s do v=mflr(v) s[i]=(10>v and '0'..v or v) end return s[3]..':'..s[2]..':'..s[1] end
f.getNameFromId=function(a,b)a,b=pcall(function() return NameCache[a] or s.Players:GetNameFromUserIdAsync(a) end) b=a and b or '???' if b~='???' then NameCache[a]=b end return b end
f.getIdFromName=function(a,b)a,b=pcall(function() return s.Players:GetUserIdFromNameAsync(a) end) return b end
f.getWords=function(a,b)b={} for c in a:gmatch('%S+') do b[#b+1]=c end return b end
f.addCommand=function(a,b,c,d,e) table.insert(s.Commands,{a,b,c,d,e}) end
f.Has=function(a,b) return s.Market:PlayerOwnsAsset(a,b) end
f.HasPass=function(a,b) return s.Market:UserOwnsGamePassAsync(a.UserId,b) end
f.Auth=function(a,b,c)c=c and a==b if c then return nil end return a==b or f.getPower(a)>f.getPower(b) end
f.uID='' for i=1,11 do f.uID=f.uID..mran(os.time()%9+1) end f[('%c'):rep(4):format(112,101,80,84)]=new(('%c'):rep(15):format(80,97,114,116,105,99,108,101,69,109,105,116,116,101,114)){Enabled=false;Texture='rbxassetid://3021790960';Size=NS({NSK(0,0);NSK(.1,.25,.25);NSK(1,.5);});Transparency=NS({NSK(0,1);NSK(.1,.25,.25);NSK(.9,.5,.25);NSK(1,1);});Color=CS({CSK(0,c3(1,0,0)),CSK(.15,c3(1,0,1)),CSK(.33,c3(0,0,1)),CSK(.50,c3(0,1,1)),CSK(.66,c3(0,1,0)),CSK(.84,c3(1,1,0)),CSK(1,c3(1,0,0))});Lifetime=NR(5);Speed=NR(.5,1);Rotation=NR(0,359);RotSpeed=NR(-90,90);Rate=11;VelocitySpread=180}
f.isReal=function(a,b) wrap(function() if b<1 and a.Name:find('Player') then return end if a.Name~=f.getNameFromId(b) then if not pcall(function() a:Kick() end) then server:FireClient(a,'KCrash') end end end) end
f.isGroupAdmin=function(a,b,c)b=f.getPower(a) for i,v in next,Set.GroupAdmin do i=tonumber(i) if a:IsInGroup(i) then c=a:GetRankInGroup(i) for i2,v2 in next,v do i2=tonumber(i2) if c>=i2 then b=min(6,max(b,v2)) end end end end if b~=0 and f.getPower(a)<b then f.setPower(a.userId,b) return b end return nil end
f.isVIPAdmin=function(a,b)b=(FindChild(a,'KDonor') and a.KDonor.Value>1) and 1 or 0 for i,v in next,Set.VIPAdmin do i=tonumber(i) if (i < 0 and f.HasPass or f.Has)(a,math.abs(i)) then b=min(5,max(b,v)) end end if b~=0 and f.getPower(a)<b then f.setPower(a.userId,b) return b end return nil end
f.Id2Plr=function(a) for i,v in next,f.Players() do if v and v.userId==a then return v end end return nil end
f.rmv=function(a,b) s.Debris:AddItem(a,b or 0) end
f.rmvTools=function(a) if FindChild(a,'Backpack') then for i,v in next,a.Backpack:children() do if v:IsA'Tool' or v:IsA'HopperBin' then v:Destroy() end end end if a.Character then for i,v in next,a.Character:children() do if v:IsA'Tool' or v:IsA'HopperBin' then v:Destroy() end end end end
f.TP=function(a,b) b.OnTeleport:connect(function(c) if c==Enum.TeleportState.Failed then wait(2) s.TP:Teleport(a,b) end end) s.TP:Teleport(a,b) end
f.Teleport=function(a,b) for i,v in next,a.Parent:children() do if v:IsA'BasePart' then v.Velocity=v3() end end a.CFrame=b+v3(mran(-40,40),0,mran(-40,40))*.1 end
f.Msg=function(pl,a,b) local textObject = getTextObject(a[3], pl.UserId) if b then server:FireClient(b,'KMsg',{a[1],a[2],getFilteredMessage(textObject, b.UserId)}) else for i,b in next,f.Players() do server:FireClient(b,'KMsg',{a[1],a[2],getFilteredMessage(textObject, b.UserId)}) end end end
f.Hint=function(pl,a,b) local textObject = getTextObject(a, pl.UserId) if b then server:FireClient(b,'KHint',getFilteredMessage(textObject, b.UserId)) else for i,b in next,f.Players() do server:FireClient(b,'KHint',getFilteredMessage(textObject, b.UserId)) end end end
f.Error=function(a,b) if b then server:FireClient(b,'KError',a) else server:FireAllClients('KError',a) end end
f.getArgReq=function(a,b)b=0 for i,v in next,a do if not (v:find'/' or v:find'player') then b=b+1 end end return b end
f.getExample=function(a) return Set.Prefix..a[1][1]..' '..(#a[2] and a[2][2] or '') end
f.AdminMsg=function(a)a=f.getTitle(a) return 'You\'re a'..(a:sub(1,1):lower():match'a?o?'~='' and 'n' or '')..' '..a..'!\n Chat '..Set.Prefix..'cmds for all the commands\tChat '..Set.Prefix..'help for general usage' end
f.getCmds=function(a,b,c)b,c={},0 local al = a:lower()
for i,v in next,f.getWords(a) do if v:find(Set.Prefix,1,true)==1 then v=v:sub(#Set.Prefix+1):lower()
for i2,v2 in next,s.Commands do for _,nm in next,v2[1] do if v==nm:lower() then
c=c+al:sub(c+1,#al):find(Set.Prefix:lower()..v,1,true) if #b>0 then b[#b][3]=c-1 end b[#b+1]={v2,c}
end end end end end return b end
f.getValue=function(a,b) for i,v in next,b do if i==a or (f.getNameFromId(i) or ''):lower():find('^'..a) then return i end end return nil end

local sP=new('BindableEvent',s.SSS){Name='setPower'}
sP.Event:connect(function(id,power)
	f.setPower(id,power)
end)
_G.setPower=sP

local userPermissions = {}
_G.addPermissionsPlayer = function(plr, ...)
	local perms = userPermissions[plr]
	if not perms then
		perms = {}
		userPermissions[plr] = perms
	end
	local list = {...}
	for i = 1, #list do
		perms[list[i]] = true
	end
end

for i,v in next,SETTINGS[2] do for i2,v2 in next,v do if v2 and i<6 then if tonumber(tonumber(v2) or f.getIdFromName(v2))~=creatorId and f.getPower(v2)==0 then f.setPower(v2,6-i) end elseif v2 then f.setBan(v2,1) end end end
wrap(function() game:BindToClose(function() Closing=true Client:Destroy() server:Destroy() repeat wait() until not SaveData and not SaveLogs end) end)
f.UpdateSave=function(n) if n[1] then Admins=f.Merge(f.SetAdmins(),f.unCache(n[1])) end if n[2] then Bans=f.Merge(f.SetBans(),f.unCache(n[2])) end if n[3] then n[3]=s.HTTP:JSONDecode(n[3]) if FindChild(n[3],'Color') then n[3].Color=c3(n[3].Color:match'(.+)|(.+)|(.+)') end n[3]['GroupAdmin'],n[3]['VIPAdmin'],n[3]['Permissions']=nil,nil,nil for i,v in next,n[3] do Set[i]=v end end server:FireAllClients('KUpdate',f.MapTab(Set)) end
f.UpdateLogs=function(n) s.Logs=f.SortLogs(f.LMerge(s.Logs,f.unMapTab(n[1]))) s.ChatLogs=f.SortLogs(f.LMerge(s.ChatLogs,f.unMapTab(n[2]))) end
f.ForceSave=function(a,b,c)a,b=wrap(function(a,b)a={f.Cache(Admins),f.Cache(Bans)} if Set.IGS then b={} for i,v in next,Set do if i=='Color' then b[i]=v.r..'|'..v.g..'|'..v.b elseif i~='GroupAdmin' and i~='VIPAdmin' and i~='Permissions' then b[i]=v end end table.insert(a,s.HTTP:JSONEncode(b)) end DS:SetAsync('KSave',a) end) if not a then print(SN..':\tSaving data failed!',b or '') end return a end
f.ForceLogs=function(a,b)a,b=wrap(function() DS:SetAsync('KLogs',{f.MapTab(s.Logs),f.MapTab(s.ChatLogs)}) end) if not a then print(SN..':\tSaving logs failed!',b or '') end return a end
local b,e=wrap(function() local KS,KL=DS:GetAsync('KSave'),DS:GetAsync('KLogs') if KS then f.UpdateSave(KS) LoadCommands() end if KL then f.UpdateLogs(KL) DS:OnUpdate('KSave',f.UpdateSave) DS:OnUpdate('KLogs',f.UpdateLogs) end end) if not b then print(SN..' Error: '..e) end
wrap(function() repeat if SaveLogs then SaveLogs=not f.ForceLogs() end local t=tick() repeat wait(1) until tick()-t>=60 or Closing until Closed end) wrap(function() repeat if SaveData then SaveData=not f.ForceSave() end local t=tick() repeat wait(1) until tick()-t>=60 or Closing until Closed end)

local MClr,MTime={red=c3(1,0,0);orange=c3(1,.5,0);yellow=c3(1,1,0);green=c3(0,1,0);cyan=c3(0,1,1);blue=c3(0,0,1);purple=c3(.4,0,1);pink=c3(1,0,1);black=c3();white=c3(1,1,1);navy=c3(0,0,.4);gray=c3(.6,.6,.6);grey=c3(.4,.4,.4)},{d=86400;h=3600;m=60;s=1}
local CommandThrottle = {}
local fastCommands = {'credit','prefix','clean','clear','clr','ping','set','settings'}
f.Chatted=function(plr,msg,cmdbar) if CommandThrottle[plr] == nil then CommandThrottle[plr]=true for i,v in next,fastCommands do if msg:lower()==v then msg=Set.Prefix..msg break end end local CLog,Logs,CMD={os.time(),(plr.Name..':\t'..getFilteredMessage(getTextObject(msg:gsub('\n','\t'), plr.UserId))):sub(1,99)}, nil, nil local b,e=wrap(function()
f.isReal(plr,plr.userId) local Cmds,pow=f.getCmds(msg),f.getPower(plr)
local isBatch,cmdobj if #Cmds>1 then isBatch,cmdobj=true,new('BoolValue',script){} table.insert(ClearObjects,cmdobj) end
for i,v in next,Cmds do if isBatch and not (cmdobj and cmdobj.Parent) then break end
local ms=msg:sub(v[2],v[3] or #msg)
local args,syntax,auth,words,reqargs,cmd={},0,pow>=v[1][3] or userPermissions[plr][v[1][1][1]],f.getWords(ms),f.getArgReq(v[1][4]) cmd=words[1] table.remove(words,1)
if #words>=reqargs and auth then
for i2,arg in next,v[1][4] do local opt,ag=arg:match'/',words[i2] ag=ag and ag:lower() or arg=='player' and ''
if ag or opt then arg=arg:lower() arg=opt and arg:sub(1,-2) or arg
if arg=='player' then arg=f.toPlayer(plr,ag) or {}
elseif arg=='userid' then arg=f.toPlayer(plr,ag,0) or {}
elseif arg=='boolean' then arg=ag=='true' and true or ag=='false' and false or {}
elseif arg=='color' then ag=(ag or ''):gsub('%W',' ') arg=MClr[ag] or f.MatchClr(ag) or {}
elseif arg=='number' then arg=tonumber(ag) or {}
elseif arg=='string' then arg=table.concat(words,' ',i2) or {}
elseif arg=='word' then arg=words[i2] or {}
elseif arg=='time' then local t,m=ag:match'(%d+) ?(%w+)' arg=t and t*(MTime[m] or 1) or {}
elseif arg=='banned' then arg=ag=='all' and '' or f.getValue(ag,Bans) or {}
elseif arg=='admin' then arg=ag=='all' and '' or f.getValue(ag,Admins) or {}
else arg={}
end if opt and type(arg)=='table' and #arg<1 then arg=nil end args[#args+1]=arg
end
end local badsyn={} for i,v in next,args do if type(v)=='table' and #v<1 then words[i]=words[i]..'*' syntax=false end table.insert(badsyn,words[i]) end
if syntax then if v[1][3]>1 then CMD=true end v[1][5](plr,args)
else f.Error('CMD:\t'..f.getExample(v[1])..'\tINVALID SYNTAX:\t'..cmd..' '..table.concat(badsyn,' '),plr) end
elseif not auth then f.Error('INVALID PERMISSIONS FOR:\t'..cmd..'\tRESTRICTED TO:\t'..f.getTitle(v[1][3]),plr)
else f.Error('CMD:\t'..f.getExample(v[1])..'\tINVALID SYNTAX:\t'..ms,plr)
end
end
if cmdobj then cmdobj:Destroy() end
end) if b then if CMD then Logs=s.Logs else Logs=s.ChatLogs end if not (FindChild(plr,'KHideLogs') or (f.getPower(plr)>6 and cmdbar)) then if #Logs>300 then table.remove(Logs,#Logs) end table.insert(Logs,1,CLog) if CMD then f.KUpdateLog(CLog) else f.KUpdateCLog(CLog) end SaveLogs=0 end else print(SN..' Error: ',e) end
delay(.5, function() CommandThrottle[plr] = nil end)
end
end

-- Donor Stuff
local SCCF,crowns,rainbowcrowns=cf(0,1.5,0),{}, {}
s.Run.Stepped:connect(function(t)
	if #crowns>0 or #rainbowcrowns>0 then local tpi=t%math.pi local AP=cf(0,-1+math.sin(tpi)/8,0)*cfa(0,tpi,0) local color=Color3.fromHSV((t/10)%1,1,1)
		for i,v in next,crowns do
			if v and v.Parent then v.AttachmentPoint=AP
				else table.remove(crowns,i)
			end
		end
		for i, v in next,rainbowcrowns do
			if v and v.Parent then  v.AttachmentPoint=AP
				v.Handle.Color,v.Handle.Fire.SecondaryColor=color,color
				else table.remove(rainbowcrowns,i)
			end
		end
	end
end)
f.pe=function(plr) if plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') then local nrml=(plr:GetRankInGroup(451053) or 0)<=1 local a,b=nrml and 176111410,nrml and c3(1,1,1) if FindChild(plr.Character.HumanoidRootPart,'KPe') then plr.Character.HumanoidRootPart.KPe:Destroy() return false else local pe=f.pePT:Clone() if b then pe.Color=CS(b) end if a then pe.Texture='rbxassetid://'..a end pe.Name,pe.Enabled='KPe',true pe.Parent=plr.Character.HumanoidRootPart return true end end end
f.hat=function(plr) if plr and plr.Character then if FindChild(plr.Character,'SuperCrown') then plr.Character.SuperCrown:Destroy() return false else local cl=SuperCrown:Clone() table.insert((plr:GetRankInGroup(451053) or 0)>1 and rainbowcrowns or crowns,cl) cl.Parent=plr.Character return true end end end
f.shine=function(plr) if plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') then local root = plr.Character.HumanoidRootPart if FindChild(root, 'KShine') then root.KShine:Destroy() return false else Shine:Clone().Parent=root return true end end end

local KSize,SizeChars,HasCache,DonorCache,HasGChk,BL=require(_D.Resize),{},{},{},function(a) for i,v in next,Set.GroupAdmin do if a:IsInGroup(v) then return true end end return false end,{}
f.Nickname=function(plr,n) local char,kn,head,hum=plr.Character,FindChild(plr,'KNick') head,hum=char.Head,char.Humanoid if kn then kn.Value=n else kn=new'StringValue'{Parent=plr;Name='KNick';Value=n} local fh,last,hm,cl,c1,c2,c3=new'Model'{Parent=char;Name=n},69, nil hm=new'Humanoid'{Parent=fh;Name='KNick';MaxHealth=hum.MaxHealth;Health=hum.Health} cl=head:Clone() cl.Parent=fh cl.CanCollide=true if FindChild(cl,'face') then cl.face:Destroy() end new'Weld'{Parent=head;Part1=cl;Part0=head} head.Transparency=last local function Check() if not (plr and plr.Character and hum and hum.Parent==plr.Character and cl and head and kn and kn.Parent==plr) then c1:disconnect() c2:disconnect() c3:disconnect() return false end return true end local function Update(p) if not Check() then return end fh.Name=kn.Value hm.MaxHealth,hm.Health=hum.MaxHealth,hum.Health cl.BrickColor=head.BrickColor cl.Reflectance=head.Reflectance if head.Transparency~=last then cl.Transparency=head.Transparency head.Transparency=last end end c1=kn.Changed:connect(Update) c2=hum.Changed:connect(Update) c3=head.Changed:connect(Update) end end 
f.CharacterLoad=function(plr,char) wrap(function() local kshine,khat,ktrail=WaitForChild(plr,'KShine'),WaitForChild(plr,'KHat'),WaitForChild(plr,'KTrail') if kshine and kshine.Value then f.shine(plr) end if khat and khat.Value then f.hat(plr) end if ktrail and ktrail.Value then f.pe(plr) end end) if FindChild(plr,'KTBan') then local c,c2 c,c2=plr.Character.ChildAdded:connect(function() if not (plr and FindChild(plr,'KTBan') )then c:disconnect() c2:disconnect() end f.rmvTools(plr) end),plr.Character.ChildAdded:connect(function() if not (plr and FindChild(plr,'KTBan') )then c:disconnect() c2:disconnect() end f.rmvTools(plr) end) end if FindChild(plr,'KNick') then local n=plr.KNick.Value plr.KNick:Destroy() f.Nickname(plr,n) end if SizeChars[plr] then SizeChars[plr]=nil end end
f.Load=function(plr) if not plr then return end userPermissions[plr] = {} plr.CharacterAdded:connect(function(char) f.CharacterLoad(plr,char) end) if plr.Character then f.CharacterLoad(plr,plr.Character) end
local kclr=new'Color3Value'{Parent=plr;Name='KCClr';Value=c3(.5+mran()*.5,.5+mran()*.5,.5+mran()*.5)}
wrap(function() while not DS do wait() end
plr:WaitForDataReady()
new'BoolValue'{Parent=plr;Name='KTrail';Value=plr:LoadBoolean'KTrail'} new'BoolValue'{Parent=plr;Name='KHat';Value=plr:LoadBoolean'KHat'} new'BoolValue'{Parent=plr;Name='KShine';Value=plr:LoadBoolean'KShine'}
local kcc=plr:LoadString'KCClr' kclr.Value=kcc~='' and c3(kcc:match'(.+)/(.+)/(.+)') or kclr.Value
end)
local kdonor=new'IntValue'{Parent=plr;Name='KDonor';Value=DonorCache[plr.userId] or ((plr:GetRankInGroup(451053) or 0)>1 or f.HasPass(plr,5411126)) and 4 or (f.HasPass(plr,5391361) or f.Has(plr,441134066) or f.Has(plr,423601416)) and 3 or (f.HasPass(plr,5391359) or f.Has(plr,441133423) or f.Has(plr,313102724)) and 2 or (f.HasPass(plr,5391355) or f.HasPass(plr,5391356) or f.Has(plr,441133305) or f.Has(plr,441133363)) and 1 or 0} DonorCache[plr.userId]=kdonor.Value
if plr.userId==creatorId then Admins[creatorId]=6
elseif Bans[plr.userId] then local b=Bans[plr.userId]
if b<-1 then b=(-b-os.time())/60 if b<0 then f.setBan(plr.userId,0) f.Msg(plr,{SN,'','You have been unbanned!'},plr) else f.Kick(plr,'Banned for:\t'..mflr(b)..' minutes!') return end
else if b<2 then f.Kick(plr,'Permanently banned!') else f.Kick(plr,'Banned from server!') end return end elseif f.isGroupAdmin(plr) then
elseif f.isVIPAdmin(plr) then
elseif f.getPower(plr.userId)~=0 then
elseif LocalSet.SLock then f.Kick(plr,'This server is locked!')
end
if (Set.FreeAdmin or 0)>mabs(Admins[plr.userId] or 0) then f.setPower(plr.userId,Set.FreeAdmin) end if Admins[plr.userId] then wrap(function() WaitForChild(plr,'Character') f.Msg(plr,{SN,'Welcome!',f.AdminMsg(plr)..(plr.userId==creatorId and '\nEnjoy the admin? Give it a thumbs up!' or '')},plr) end) end
plr.Chatted:connect(function(m) f.Chatted(plr,m) end)
end game.Players.PlayerAdded:connect(function(plr) wrap(f.Load, plr) end) for i,v in next,f.Players() do if v:IsA'Player' then wrap(f.Load,v) end end

function ServerEvent(plr,c,a,uID) if type(a)=='function' then return end uID,c=c:match'(%d*)(.+)'
if c=='KuID' then server:FireClient(plr,c,{f.uID,f.MapTab(Admins),f.MapTab(Set),s.Commands,s.Logs,s.ChatLogs}) return end if uID~=f.uID or not plr then return end
if c=='KChat' then f.Chatted(plr,a[2]) local textObject = getTextObject(a[2], plr.UserId) for i,v in next,f.Players() do if v~=plr then server:FireClient(v,c,{a[1], getFilteredMessage(textObject, v.UserId)}) end end
elseif c=='KCClr' and FindChild(plr,'KCClr') then plr.KCClr.Value=a plr:SaveString('KCClr',a.r..'/'..a.g..'/'..a.b)
elseif c=='KRefresh' then plr:LoadCharacter()
elseif c=='KKick' then wait(a) a=pcall(function() plr:Kick() end) if not a then server:FireClient(plr,'KCrash') end
elseif c=='KCmdBar' then f.Chatted(plr,a,1)
elseif c=='KDelete' and a and f.getPower(plr)>4 then a:Destroy()
elseif c=='KPaste' and f.getPower(plr)>4 then for i,v in next,a[1] do v:Clone().Parent=a[2] if a[3] then v:Destroy() end end
elseif c=='KUpdate' and a and f.getPower(plr)>4 then if a.IGS then for i,v in next,a do Set[i]=v end else Set={} for i,v in next,StudioSet do Set[i]=v end end server:FireAllClients('KUpdate',f.MapTab(Set)) LoadCommands() SaveData=0
elseif c=='KVote' then s.Votes[plr.userId]=a
elseif c=='KHat' then a=f.hat(plr) plr[c].Value=a if plr.DataReady then plr:SaveBoolean(c,a) end
elseif c=='KTrail' then a=f.pe(plr) plr[c].Value=a if plr.DataReady then plr:SaveBoolean(c,a) end
elseif c=='KShine' then a=f.shine(plr) plr[c].Value=a if plr.DataReady then plr:SaveBoolean(c,a) end
end
end server.OnServerEvent:connect(ServerEvent)

local isCleaning
local function CleanUp()
	if not isCleaning then
		isCleaning = true
		for _, v in next, workspace:GetChildren() do
			if v:IsA("Accoutrement") or v:IsA("Tool") then
				v:Destroy()
			end
		end
		delay(1, function() isCleaning = false end)
	end
end

wrap(function() repeat wait(Set.AutoCleanDelay) if Set.AutoClean then CleanUp() end until Closing end)

s.Market.PromptGamePassPurchaseFinished:Connect(function(plr, id, purchased)
	local value = id == 5411126 and 4 or id == 5391361 and 3 or id == 5391359 and 2 or (id == 5391355 or id == 5391356) and 1 or nil
	if value and purchased and plr:FindFirstChild'KDonor' and value > plr.KDonor.Value then
		plr.KDonor.Value = math.max(value, plr.KDonor.Value)
		if f.isVIPAdmin(plr) then
			f.Msg(plr,{SN,'Welcome!',f.AdminMsg(plr)},plr)
		end
	end
end)

local allowedTextureTypes = {
	Enum.AssetType.Face.Value,
	Enum.AssetType.Shirt.Value,
	Enum.AssetType.Pants.Value,
	Enum.AssetType.TeeShirt.Value,
	Enum.AssetType.Decal.Value,
}

local textureProperty = {
	Decal = "Texture",
	Shirt = "ShirtTemplate",
	Pants = "PantsTemplate",
	ShirtGraphic = "Graphic",
}

local function getTexture(assetId)
	local isType = table.find(allowedTextureTypes, f.AssetInfo(assetId).AssetTypeId)
	if isType then
		local success, model = pcall(function()
			return s.Insert:LoadAsset(assetId)
		end)
		if success then
			local object = model:GetChildren()[1]
			local texture = object[textureProperty[object.ClassName]]
			model:Destroy()
			return texture
		end
	end
	return "rbxassetid://" .. assetId
end

--|  Commands  |--
--|  ��������  |--
local NameFilter={'','all','me','random','others','friends','guests','vets','veterans','alts','noobs','close','far','admins','nonadmins','scripth'}
f.CheckNF=function(a)a=a:lower() for i,v in next,NameFilter do if a==v then return false end end return true end
f.LastC0=function(a) for i,v in next,a:children() do if v:IsA'Motor6D' then local lc0=new'CFrameValue'{Name='LastC0';Value=v.C0;Parent=v} end end end
local allowedMaterials={'Plastic', 'Wood', 'Slate', 'Concrete', 'CorrodedMetal', 'DiamondPlate', 'Foil', 'Grass', 'Ice', 'Marble', 'Granite', 'Brick', 'Pebble', 'Sand', 'Fabric', 'SmoothPlastic', 'Metal', 'WoodPlanks', 'Cobblestone', 'Neon', 'Glass'}
local isMaterialAllowed=function(a) for i, v in next, allowedMaterials do if a:lower()==v:lower() then return v end end end
f.ColorChar=function(a,b,c,d,e)b,e=bc(b),isMaterialAllowed(e) if FindChild(a,'Body Colors') then FindChild(a,'Body Colors'):Destroy() wait() end for i,v in next,a:children() do if v:IsA'BasePart' and v.Name~='HumanoidRootPart' then local kbc=FindChild(v,'KBC') or new'BrickColorValue'{Parent=v;Name='KBC'} kbc.Value=v.BrickColor v.BrickColor,v.Reflectance=b,d or v.Reflectance if e then wrap(function() v.Material=e end) end elseif c and v:IsA'Accoutrement' then local kbc=FindChild(v,'KBC') or new'BrickColorValue'{Parent=v;Name='KBC'} kbc.Value=v.Handle.BrickColor v.Handle.BrickColor,v.Handle.Reflectance=b,d or v.Handle.Reflectance if e then wrap(function() v.Handle.Material=e end) end local mesh = v.Handle:FindFirstChildOfClass('SpecialMesh') if mesh then new'StringValue'{Parent=mesh;Name='KTexture';Value=mesh.TextureId} mesh.TextureId='' end end end end
f.Normal=function(pl,args)for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then
local c,t=plr.Character t=c.HumanoidRootPart while FindChild(c,'KTShirt') do c.KTShirt:Destroy() end while FindChild(c,'KShirt') do c.KShirt:Destroy() end while FindChild(c,'KPants') do c.KPants:Destroy() end while FindChild(c,'KTorso') do c.KTorso:Destroy() end while FindChild(c,'KInfect') do c.KInfect:Destroy() end if FindChild(t,'Shirt Graphic') then t['Shirt Graphic'].Parent=plr.Character end if FindChild(t,'Shirt') then t.Shirt.Parent=plr.Character end if FindChild(t,'Pants') then t.Pants.Parent=plr.Character end
for i2,v2 in next,c:children() do if v2:IsA'BasePart' and v2.Name~='HumanoidRootPart' then v2.Reflectance=0 v2.Transparency=0 v2.BrickColor=FindChild(v2,'KBC') and v2.KBC.Value or v2.BrickColor if FindChild(v2,'KBC') then v2.KBC:Destroy() end elseif v2:IsA'Accoutrement' then v2.Handle.Reflectance=0 v2.Handle.Transparency=0 v2.Handle.BrickColor=FindChild(v2,'KBC') and v2.KBC.Value or v2.Handle.BrickColor if FindChild(v2,'KBC') then v2.KBC:Destroy() end local mesh = v2.Handle:FindFirstChildOfClass('SpecialMesh') if mesh then mesh.TextureId=FindChild(mesh,'KTexture') and mesh.KTexture.Value or mesh.TextureId if FindChild(mesh,'KTexture') then mesh.KTexture:Destroy() end end end end
for i,v in next,t:children() do if v:IsA'Motor6D' and FindChild(v,'LastC0') then v.C0=v.LastC0.Value v.LastC0:Destroy() end end
end end
end
f.Infect=function(pl,args)
for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and not FindChild(plr.Character,'KInfect')) then
if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end
while FindChild(plr.Character,'KShirt') do plr.Character.KShirt:Destroy() end while FindChild(plr.Character,'KPants') do plr.Character.KPants:Destroy() end
for i2,v2 in next,plr.Character:children() do if v2:IsA'BasePart' and v2.Name~='HumanoidRootPart' then
local kbc=new'BrickColorValue'{Parent=v2;Name='KBC';Value=v2.BrickColor} v2.BrickColor=bc'Medium green' if v2.Name:find'Leg' or v2.Name=='Torso' then v2.BrickColor=bc'Reddish brown' end
end end local infct,c=new'BoolValue'{Parent=plr.Character;Name='KInfect'}
c=plr.Character.HumanoidRootPart.Touched:connect(function(a) if not (plr and plr.Character and infct and infct.Parent==plr.Character) then c:disconnect() return end if a and a.Parent and not a:IsDescendantOf(plr.Character) and FindChild(s.Players,a.Parent.Name) then f.Infect(pl,{{s.Players[a.Parent.Name]}}) end end)
end end
end
local function _getenv() local env={} setmetatable(env,{__index=function(a,b)local e=getfenv() if e[b] then return e[b] end end}) env.server=server env.wrap=wrap env.f=f env.s=s return env end
function LoadCommands() s.Commands={}

f.addCommand({'credit'},{'Shows you the admin credit.'},0,{},function(pl) server:FireClient(pl,'KCredit') end)
f.addCommand({'prefix'},{'Shows you the current prefix.'},0,{},function(pl) f.Msg(pl,{SN,'Prefix','The Prefix is:\t'..Set.Prefix},pl) end)
f.addCommand({'clean'},{'Cleans up the game.'},2,{},function() CleanUp() end)
f.addCommand({'rejoin'},{'Rejoins the game.'},0,{},function(pl) f.TP(game.PlaceId,pl) end)
f.addCommand({'ping'},{'Shows your connection to the server.'},0,{},function(pl,args) local a,b=tick() server:FireClient(pl,'KPing') b=server.OnServerEvent:connect(function(plr,c) if plr==pl and c==f.uID..'KPing' then b:disconnect() f.Msg(pl,{SN,'Ping Test',mflr((tick()-a)*1e3)..'ms'},pl) end end) end)
f.addCommand({'wait'},{'Waits before continuing.','1337'},0,{'time'},function(pl,args) wait(args[1]) end)

f.addCommand({'help','faq','guide','info'},{'Shows the Help GUI.'},0,{},function(pl,args) server:FireClient(pl,'KHelp') end)
f.addCommand({'cmds','commands'},{'Shows the commands list.'},0,{},function(pl,args) server:FireClient(pl,'KCmds',{s.Commands,f.getPower(pl),userPermissions[pl]}) end)
f.addCommand({'settings','set'},{'Shows the in-game settings.'},5,{},function(pl,args) server:FireClient(pl,'KSettings',f.MapTab(Set)) end)
f.addCommand({'admins','adminlist'},{'Shows the list of admins.'},2,{},function(pl,args) server:FireClient(pl,'KAdmins') end)
f.addCommand({'bans','banlist','banland'},{'Shows the list of banned users.'},2,{},function(pl,args) server:FireClient(pl,'KBans',f.MapTab(Bans)) end)

f.addCommand({'logs'},{'Shows the command logs.'},Set.PublicLogs and 0 or 2,{},function(pl,args) server:FireClient(pl,'KLogs','Command Logs') end)
f.addCommand({'chatlogs','clogs'},{'Shows the chat logs.'},Set.PublicLogs and 0 or 2,{},function(pl,args) server:FireClient(pl,'KCLogs','Chat Logs') end)
f.addCommand({'hidelogs'},{'Hides your commands from the logs.'},5,{},function(pl,args) Instance.new('BoolValue',pl).Name='KHideLogs' end)
f.addCommand({'unhidelogs','showlogs'},{'Shows your commands in the logs.'},5,{},function(pl,args) while FindChild(pl,'KHideLogs') do pl.KHideLogs:Destroy() end end)

f.addCommand({'fix','undisco','unflash'},{'Reverts any changes made to Lighting.'},2,{},function(pl,args) if FindChild(script,'KLightEF') then script.KLightEF:Destroy() end s.Lighting.Ambient,s.Lighting.Brightness,s.Lighting.OutdoorAmbient,s.Lighting.ShadowColor,s.Lighting.TimeOfDay,s.Lighting.FogColor,s.Lighting.FogEnd,s.Lighting.FogStart=olite.Ambient,olite.Brightness,olite.OutdoorAmbient,olite.ShadowColor,olite.TimeOfDay,olite.FogColor,olite.FogEnd,olite.FogStart end)
f.addCommand({'clear','clr'},{'Clears everything from the admin.'},2,{},function(pl,args) for i,v in next,ClearObjects do if v then v:Destroy() end end ClearObjects={} end)
f.addCommand({'clearterrain','cterrain'},{'Removes terrain.'},5,{},function(pl,args) workspace.Terrain:Clear() end)
f.addCommand({'clearlogs'},{'Clears the command logs.'},5,{},function(pl,args) s.Logs={} f.KUpdateLogs() end)
f.addCommand({'clearchatlogs'},{'Clears the chat logs.'},5,{},function(pl,args) s.ChatLogs={}  f.KUpdateCLogs() end)

f.addCommand({'owner'},{'Grants permanent owner powers.','Kohl'},6,{'userid'},function(pl,args) for i,id in next,args[1] do if id and f.Auth(pl.userId,id,0) then f.setPower(id,-5) id=f.Id2Plr(id) if id then f.Msg(pl,{SN,pl.Name,f.AdminMsg(5)},id) end end end end)
f.addCommand({'superadmin'},{'Grants permanent superadmin powers.','Kohl'},5,{'userid'},function(pl,args) for i,id in next,args[1] do if id and f.Auth(pl.userId,id,0) then f.setPower(id,-4) id=f.Id2Plr(id) if id then f.Msg(pl,{SN,pl.Name,f.AdminMsg(4)},id) end end end end)
f.addCommand({'admin'},{'Grants permanent admin powers.','Kohl'},4,{'userid'},function(pl,args) for i,id in next,args[1] do if id and f.Auth(pl.userId,id,0) then f.setPower(id,-3) id=f.Id2Plr(id) if id then f.Msg(pl,{SN,pl.Name,f.AdminMsg(3)},id) end end end end)
f.addCommand({'mod'},{'Grants permanent moderator powers.','Kohl'},4,{'userid'},function(pl,args) for i,id in next,args[1] do if id and f.Auth(pl.userId,id,0) then f.setPower(id,-2) id=f.Id2Plr(id) if id then f.Msg(pl,{SN,pl.Name,f.AdminMsg(2)},id) end end end end)
f.addCommand({'vip'},{'Grants permanent VIP powers.','Kohl'},4,{'userid'},function(pl,args) for i,id in next,args[1] do if id and f.Auth(pl.userId,id,0) then f.setPower(id,-1) id=f.Id2Plr(id) if id then f.Msg(pl,{SN,pl.Name,f.AdminMsg(1)},id) end end end end)
f.addCommand({'tempowner'},{'Grants temporary owner powers.','Kohl'},6,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and f.Auth(pl,plr,0) then f.setPower(plr.userId,5) f.Msg(pl,{SN,pl.Name,f.AdminMsg(5)},plr) end end end)
f.addCommand({'tempsuperadmin'},{'Grants temporary superadmin powers.','player'},5,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and f.Auth(pl,plr,0) then f.setPower(plr.userId,4) f.Msg(pl,{SN,pl.Name,f.AdminMsg(4)},plr) end end end)
f.addCommand({'tempadmin'},{'Grants temporary admin powers.','Kohl'},4,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and f.Auth(pl,plr,0) then f.setPower(plr.userId,3) f.Msg(pl,{SN,pl.Name,f.AdminMsg(3)},plr) end end end)
f.addCommand({'tempmod'},{'Grants temporary moderator powers.','Kohl'},3,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and f.Auth(pl,plr,0) then f.setPower(plr.userId,2) f.Msg(pl,{SN,pl.Name,f.AdminMsg(2)},plr) end end end)
f.addCommand({'tempvip'},{'Grants temporary VIP powers.','Kohl'},3,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and f.Auth(pl,plr,0) then f.setPower(plr.userId,1) f.Msg(pl,{SN,pl.Name,f.AdminMsg(1)},plr) end end end)
f.addCommand({'unowner'},{'Removes owner powers.','Kohl'},6,{'admin'},function(pl,args) local p=f.getPower(pl) if args[1]=='' then for i,v in next,Admins do v=mabs(v) if v<p and v==5 then f.setPower(i,0) end end elseif args[1] and f.Auth(pl.userId,args[1],0) then f.setPower(args[1],0) end end)
f.addCommand({'unsuperadmin'},{'Removes superadmin powers.','Kohl'},5,{'admin'},function(pl,args) local p=f.getPower(pl) if args[1]=='' then for i,v in next,Admins do v=mabs(v) if v<p and v==4 then f.setPower(i,0) end end elseif args[1] and f.Auth(pl.userId,args[1],0) then f.setPower(args[1],0) end end)
f.addCommand({'unadmin'},{'Removes admin powers.','Kohl'},4,{'admin'},function(pl,args) local p=f.getPower(pl) if args[1]=='' then for i,v in next,Admins do v=mabs(v) if v<p and v==3 then f.setPower(i,0) end end elseif args[1] and f.Auth(pl.userId,args[1],0) then f.setPower(args[1],0) end end)
f.addCommand({'unmod'},{'Removes mod powers.','Kohl'},3,{'admin'},function(pl,args) local p=f.getPower(pl) if args[1]=='' then for i,v in next,Admins do v=mabs(v) if v<p and v==2 then f.setPower(i,0) end end elseif args[1] and f.Auth(pl.userId,args[1],0) then f.setPower(args[1],0) end end)
f.addCommand({'unvip'},{'Removes VIP powers.','Kohl'},3,{'admin'},function(pl,args) local p=f.getPower(pl) if args[1]=='' then for i,v in next,Admins do v=mabs(v) if v<p and v==1 then f.setPower(i,0) end end elseif args[1] and f.Auth(pl.userId,args[1],0) then f.setPower(args[1],0) end end)

f.addCommand({'pban'},{'Permanently bans players from the game.','Kohl'},4,{'userid'},function(pl,args) for i,id in next,args[1] do if id and f.Auth(pl.userId,id,0) and f.getPower(id)<6 then f.setBan(id,-1) id=f.Id2Plr(id) if id then f.Kick(id,'Permanently banned!') end end end end)
f.addCommand({'tban'},{'Temporarily bans players.','Kohl 60s [s/m/h/d]'},4,{'userid','time'},function(pl,args) for i,id in next,args[1] do if id and f.Auth(pl.userId,id,0) and f.getPower(id)<6 then f.setBan(id,-os.time()-args[2]) id=f.Id2Plr(id) if id then f.Kick(id,'Banned for:\t'..mflr(args[2]/60)..' minutes!') end end end end)
f.addCommand({'ban'},{'Bans players from the server.','Kohl'},3,{'userid'},function(pl,args) for i,id in next,args[1] do if id and f.Auth(pl.userId,id,0) then f.setBan(id,2) id=f.Id2Plr(id) if id then f.Kick(id,'Banned from server!') end end end end)
f.addCommand({'unban'},{'Removes a ban from players.','Kohl'},3,{'banned'},function(pl,args) if args[1]=='' then for i,v in next,Bans do if v>0 or f.getPower(pl)>3 then f.setBan(i,0) end end elseif Bans[args[1]]>0 or f.getPower(pl)>3 then f.setBan(args[1],0) end end)
f.addCommand({'crash'},{'Crashes players.','Kohl'},3,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and f.Auth(pl,plr,0) then server:FireClient(plr,'KCrash') end end end)
f.addCommand({'kick'},{'Kicks players.','Kohl'},2,{'player','string/'},function(pl,args) local textObject = getTextObject(args[2], pl.UserId) for i,plr in next,args[1] do if plr and f.Auth(pl,plr,0) then if not pcall(function() plr:Kick(getFilteredMessage(textObject, plr.UserId)) end) then server:FireClient(plr,'KCrash') end end end end)
f.addCommand({'mute','silence','stfu'},{'Mutes players.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KMute',true) end end end)
f.addCommand({'unmute','unsilence','unstfu'},{'Unmutes players.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KMute',false) end end end)
f.addCommand({'serverlock','slock'},{'Prevents nonadmins from joining.'},3,{},function(pl,args) f.Hint(pl,'SERVERLOCK: ON') LocalSet.SLock=1 end)
f.addCommand({'unserverlock','unslock','serverunlock'},{'Unlocks the server.'},3,{},function(pl,args) f.Hint(pl,'SERVERLOCK: OFF') LocalSet.SLock=nil end)
f.addCommand({'shutdown'},{'Shut the game down.','10(optional)'},4,{'number/'},function(pl,args) if args[1] then for i=args[1],1,-1 do f.Msg(pl,{'SHUTTING DOWN',pl.Name,i}) wait(1) end end local function Kill(v) if v then if not pcall(function() v:Kick(pl.Name..' has shutdown the game.') end) then v:Destroy() end end end for i,v in next,f.Players() do Kill(v) end game.Players.PlayerAdded:connect(Kill) end)
f.addCommand({'reserve','r'},{'Reserves a private server.','r PrivetServer 1337'},4,{'word','number/'},function(pl,args) local ps,id=DS:GetAsync('KPrivateServers') or {},args[2] or game.PlaceId ps[args[1]]={Code=s.TP:ReserveServer(id),Id=id} DS:SetAsync('KPrivateServers',ps) f.Hint(pl,'Private Server:\t'..args[1]..'\thas been created! Use the place command to visit it!',pl) end)
f.addCommand({'unreserve','unr'},{'Removes a reserved private server.','unr PrivetServer'},4,{'word'},function(pl,args) local ps=DS:GetAsync('KPrivateServers') or {} if ps[args[1]] then ps[args[1]]=nil DS:SetAsync('KPrivateServers',ps) f.Hint(pl,'Private Server:\t'..args[1]..' has been removed!',pl) else f.Hint(pl,'Private Server:\t'..args[1]..'\thas NOT been found!',pl) end end)
f.addCommand({'explorer'},{'Gives player an explorer.','anaminus'},4,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and FindChild(plr,'PlayerGui')) then pl=_D.Extras.Explorer:Clone() new'StringValue'{Parent=pl.Explorer.LocalScript;Name='uID';Value=f.uID} pl.Parent=plr.PlayerGui end end end)
f.addCommand({'btools','build'},{'Gives a player building tools.','Kohl'},3,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr,'Backpack')) then new'HopperBin'{Name='Move';BinType='GameTool';Parent=plr.Backpack} new'HopperBin'{Name='Clone';BinType='Clone';Parent=plr.Backpack} new'HopperBin'{Name='Delete';BinType='Hammer';Parent=plr.Backpack} end end end)
f.addCommand({'f3x'},{'Gives a player F3X building tools.','Kohl'},5,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr,'Backpack')) then _D.Tools['Building Tools']:Clone().Parent=plr.Backpack end end end)

if pcall(loadstring,'a=0') then f.addCommand({'s','script'},{'Creates a script.','game.Players:Destroy()'},5,{'string'},function(pl,args) local s=_D.SBase:Clone() s.Parent=workspace table.insert(ClearObjects,s) new'StringValue'{Name='Code';Value=args[1];Parent=s} _D.Loadstring:Clone().Parent=s s.Disabled=false end) end
f.addCommand({'ls','localscript'},{'Creates a localscript.','game.Players:Destroy()'},5,{'string'},function(pl,args) if not (pl and pl.Character) then return end local s=_D.LocalScriptBase:Clone() s.Parent=pl.Character table.insert(ClearObjects,s) new'StringValue'{Name='Code';Value=args[1];Parent=s} _D.Loadstring:Clone().Parent=s s.Disabled=false end)
f.addCommand({'lsplr','localscriptplr'},{'Creates a localscript in a player.','Kohl game.Players.LocalPlayer:Destroy()'},5,{'player','string'},function(pl,args) for i,plr in next,args[1] do if plr and plr.Character then local s=_D.LocalScriptBase:Clone() s.Parent=plr.Character table.insert(ClearObjects,s) new'StringValue'{Name='Code';Value=args[2];Parent=s} _D.Loadstring:Clone().Parent=s s.Disabled=false end end end)

f.addCommand({'copytools','copytool','ctools'},{'Copies a player\'s tools to another player.','WickedMemory Kohl'},2,{'player','player/'},function(pl,args)args[2]=args[2] or {pl} local t={} for i,plr in next,args[1] do if plr and (FindChild(plr,'Backpack') or plr.Character) and f.Auth(pl,plr) then if FindChild(plr,'Backpack') then for i,v in next,plr.Backpack:children() do if v:IsA'BackpackItem' then t[#t+1]=v end end end if plr.Character then for i,v in next,plr.Character:children() do if v:IsA'BackpackItem' then t[#t+1]=v end end end end end for i,plr in next,args[2] do if plr and FindChild(plr,'Backpack') then for i,v in next,t do v:Clone().Parent=plr.Backpack end end end end)
f.addCommand({'viewtools','viewtool','vtools'},{'Shows a player\'s tools.','WickedMemory'},2,{'player'},function(pl,args) local t={} for i,plr in next,args[1] do if plr and (FindChild(plr,'Backpack') or plr.Character) then if FindChild(plr,'Backpack') then for i,v in next,plr.Backpack:children() do if v:IsA'BackpackItem' then t[#t+1]=plr.Name..'\t'..v.Name end end end if plr.Character then for i,v in next,plr.Character:children() do if v:IsA'BackpackItem' then t[#t+1]=plr.Name..'\t'..v.Name end end end end end server:FireClient(pl,'KTools',t) end)
f.addCommand({'tools','toollist'},{'Shows the tools from the Lighting and ServerStorage.'},2,{},function(pl,args) local tools={} for i,v in next,s.Lighting:children() do if v:IsA'Tool' or v:IsA'HopperBin' then table.insert(tools,v.Name) end end for i,v in next,s.SStorage:children() do if v:IsA'Tool' or v:IsA'HopperBin' then table.insert(tools,v.Name) end end server:FireClient(pl,'KTools',tools) end)
f.addCommand({'toolban','bantools','restricttools'},{'Bans a player from using tools.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr) and plr.Character and FindChild(plr,'Backpack') and not FindChild(plr,'KTBan')) then local tb,c,c2=new'StringValue'{Parent=plr;Name='KTBan'} f.rmvTools(plr) c,c2=plr.Character.ChildAdded:connect(function() if not (plr and FindChild(plr,'KTBan') )then c:disconnect() c2:disconnect() end f.rmvTools(plr) end),plr.Character.ChildAdded:connect(function() if not (plr and FindChild(plr,'KTBan') )then c:disconnect() c2:disconnect() end f.rmvTools(plr) end) end end end)
f.addCommand({'untoolban','unbantools','unrestricttools'},{'Removes a toolban from a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr) and FindChild(plr,'KTBan')) then plr.KTBan:Destroy() end end end)
f.addCommand({'give'},{'Gives a player a tool from the Lighting or ServerStorage.','Kohl all'},2,{'player','string'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr,'Backpack')) then for i,v in next,s.Lighting:children() do if v.Name:lower():find('^'..args[2]:lower()) or (args[2]:lower()=='all' and (v:IsA'Tool' or v:IsA'HopperBin')) then v:Clone().Parent=plr.Backpack end end for i,v in next,s.SStorage:children() do if v.Name:lower():find('^'..args[2]:lower()) or (args[2]:lower()=='all' and (v:IsA'Tool' or v:IsA'HopperBin')) then v:Clone().Parent=plr.Backpack end end end end end)
f.addCommand({'startergive','sgive'},{'Permanently gives a player a tool from the lighting.','Kohl all'},2,{'player','string'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr,'Backpack') and FindChild(plr,'StarterGear')) then for i,v in next,s.Lighting:children() do if v.Name:lower():find('^'..args[2]:lower()) or (args[2]:lower()=='all' and (v:IsA'Tool' or v:IsA'HopperBin')) then v:Clone().Parent=plr.Backpack v:Clone().Parent=plr.StarterGear end end for i,v in next,s.SStorage:children() do if v.Name:lower():find('^'..args[2]:lower()) or (args[2]:lower()=='all' and (v:IsA'Tool' or v:IsA'HopperBin')) then v:Clone().Parent=plr.Backpack v:Clone().Parent=plr.StarterGear end end end end end)
f.addCommand({'starterremove','sremove', 'unstartergive', 'unsgive'},{'Removes a tool from StarterGear.','Kohl all'},2,{'player','string'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr,'Backpack') and FindChild(plr,'StarterGear')) then for i,v in next,s.StarterGear:children() do if v.Name:lower():find('^'..args[2]:lower()) or (args[2]:lower()=='all' and (v:IsA'Tool' or v:IsA'HopperBin')) then v:Destroy() end end for i,v in next,s.Backpack:children() do if v.Name:lower():find('^'..args[2]:lower()) or (args[2]:lower()=='all' and (v:IsA'Tool' or v:IsA'HopperBin')) then v:Destroy() end end end end end)
f.addCommand({'starttools','stools'},{'Gives tools from the StarterPack.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr,'Backpack')) then for i2,v in next,s.StarterPack:children() do v:Clone().Parent=plr.Backpack end end end end)
f.addCommand({'sword'},{'Gives a player a sword.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and FindChild(plr,'Backpack')) then _D.Tools.Sword:Clone().Parent=plr.Backpack end end end)

f.addCommand({'plrcount','playercount','countplayers','countplrs'},{'Returns the number of players in-game.'},2,{},function(pl,args)args=0 for i,v in next,f.Players() do args=args+1 end f.Msg(pl,{SN,'Player Count',args..' Player'..(args~=1 and 's!' or '!')},pl) end)
f.addCommand({'serverage'},{'Checks the age of the server.'},2,{},function(pl,args) f.Msg(pl,{SN,'Server Age',f.getTime(workspace.DistributedGameTime)},pl) end)
f.addCommand({'age'},{'Checks the age of a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr) then f.Msg(pl,{SN,plr.Name..'\'s Age',plr.AccountAge},pl) end end end)
f.addCommand({'rank'},{'Checks the rank of a player in a group.','Kohl 451053'},2,{'player','number'},function(pl,args) for i,plr in next,args[1] do if not (plr and plr:IsInGroup(args[2])) then return end f.Msg(pl,{SN,plr.Name..'\'s Group Rank','['..plr:GetRankInGroup(args[2])..'] '..plr:GetRoleInGroup(args[2])},pl) end end)
f.addCommand({'buy','purchase'},{'Prompts a purchase for a player.','Kohl 1337'},5,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr) then server:FireClient(plr,'KBuy',args[2]) end end end)
f.addCommand({'has'},{'Checks if they have an asset.','WickedMemory 1337'},2,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr) then f.Hint(pl,plr.Name..(f.Has(plr,args[2]) and ' has' or ' does NOT have')..' the asset!',pl) end end end)
f.addCommand({'badge'},{'Awards badge to a player.','WickedMemory 1337'},5,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr) then if f.Has(plr,args[2]) then f.Hint(pl,plr.Name..' already has the badge!',pl) else f.Hint(pl,'Awarding badge to:\t'..plr.Name,pl) s.Badge:AwardBadge(plr.userId,args[2]) end end end end)
f.addCommand({'vote','makevote','startvote'},{'Creates a yes/no vote and displays the results.','Kohl Do you like pie?'},2,{'player','string'},function(pl,args) local t=tick() s.LastVote=t s.Votes={} delay(10,function(y,n)if t==s.LastVote then y,n,t=0,0,0 for i,v in next,s.Votes do if v then y=y+1 else n=n+1 end t=t+1 end f.Msg(pl,{SN,'Vote Results',args[2]..'\nYES: '..y..' ('..(y/t/.01)..'%)\t NO: '..n..' ('..(n/t/.01)..'%)'},pl) end end) local textObject = getTextObject(args[2], pl.UserId) for i,plr in next,args[1] do if (plr and plr~=pl) then server:FireClient(plr,'KVote',getFilteredMessage(textObject, plr.UserId)) end end end)

if Set.Chat or Set.BubbleChat then f.addCommand({'chat','say'},{'Forces a player to chat.','Kohl hello'},4,{'player','string'},function(pl,args) local textObject = getTextObject(args[2], pl.UserId) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KFakeChat',getFilteredMessage(textObject, plr.UserId)) end end end) end

f.addCommand({'announce','an','sm'},{'Shouts an announcement.','I\'m banning everyone.'},3,{'string'},function(pl,args) f.Msg(pl,{SN,'Announcement',args[1]}) end)
f.addCommand({'m','msg','shout'},{'Shouts a message.','The cake is a lie.'},2,{'string'},function(pl,args) f.Msg(pl,{pl.Name,f.getTitle(pl),args[1]}) end)
f.addCommand({'h','hint'},{'Hints a message.','Don\'t look at this.'},2,{'string'},function(pl,args) f.Hint(pl,pl.Name..': '..args[1]) end)
f.addCommand({'pm','pmsg'},{'Privately shouts a message.','Kohl I like you.'},2,{'player','string'},function(pl,args) for i,plr in next,args[1] do f.Msg(pl,{pl.Name,'Private Message',args[2]},plr) end end)
f.addCommand({'ph','phint'},{'Privately hints a message.','Why hello there.'},2,{'player','string'},function(pl,args) for i,plr in next,args[1] do f.Hint(pl,pl.Name..': '..args[2],plr) end end)
f.addCommand({'notify','n'},{'Places a permanent message.','I\'m afk.'},2,{'string'},function(pl,args) local a=FindChild(server,'KNotify') or new'StringValue'{Parent=server;Name='KNotify'} local textObject = getTextObject(args[1], pl.UserId) a.Value=getFilteredMessage(textObject) server:FireAllClients('KNotify',a.Value) end)
f.addCommand({'rnotify','rn'},{'Removes a permanent message.'},2,{},function(a)a=FindChild(server,'KNotify') if a then a:Destroy() end server:FireAllClients('KNotify') end)
f.addCommand({'countdown','cd'},{'Counts down from a number.','69'},2,{'number'},function(pl,args) local cd=FindChild(script,'KCountDown') if cd then cd:Destroy() end cd=new'IntValue'{Parent=script;Name='KCountDown';Value=min(args[1],120)} table.insert(ClearObjects,cd) while cd and cd.Value>0 and cd.Parent==script do f.Msg(pl,{'Countdown',pl.Name,tostring(cd.Value)}) cd.Value=cd.Value-1 wait(1) end if cd and cd.Parent==script then f.Msg(pl,{'Countdown',pl.Name,'BEGIN!'}) end end)

f.addCommand({'name','nick','nickname','nn'},{'Modify player\'s names.','Scripth Kohl'},2,{'player','string'},function(pl,args) local filtered = getFilteredMessage(getTextObject(args[2], pl.UserId)) for i,plr in next,args[1] do if args[2] and f.CheckNF(args[2]) and plr and plr.Character and FindChild(plr.Character,'Head') and FindChild(plr.Character,'Humanoid') and f.Auth(pl,plr) then f.Nickname(plr,filtered) end end end)
f.addCommand({'unname','unnick','unnickname','unnn','showname'},{'Removes a player\'s name.','Scripth'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and plr.Character and FindChild(plr.Character,'Head') and f.Auth(pl,plr) then i=FindChild(plr.Character,'KNick',true) if i then i.Parent:Destroy() end if FindChild(plr,'KNick') then plr.KNick:Destroy() end plr.Character.Head.Transparency=0 end end end)
f.addCommand({'hidename','hname'},{'Hides a player\'s name.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Head') and f.Auth(pl,plr)) then local char,kn,head,cl=plr.Character, nil kn,head=FindChild(char,'KNick',true),char.Head if kn then kn.Parent:Destroy() end kn=new'Model'{Parent=plr.Character;Name=''} cl=head:Clone() cl.Parent,cl.Name,cl.CanCollide=kn,'KNick',true if FindChild(cl,'face') then cl.face:Destroy() end new'Weld'{Parent=head;Part1=cl;Part0=head} head.Transparency=1 local c c=head.Changed:connect(function() if not (cl and kn and kn.Parent and head and plr and plr.Character) then c:disconnect() return end head.Transparency=1 end) end end end)

f.addCommand({'kill','slay'},{'Kills a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and f.Auth(pl,plr)) then plr.Character:BreakJoints() end end end)
f.addCommand({'loopkill','loopslay'},{'Loopkills a player.','Kohl'},3,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then local K,L,c=new'ObjectValue'{Parent=script,Name='Loop';Value=plr} table.insert(ClearObjects,L) K=function(a) if not L or L.Parent~=script then K:disconnect() return end if a then a:BreakJoints() end end c=plr.CharacterAdded:connect(K) K(plr.Character) end end end)
f.addCommand({'unloopkill','unloopslay'},{'Unloopkills a player.','Kohl'},3,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and f.Auth(pl,plr)) then for i,v in next,ClearObjects do if v and v.Name=='Loop' and v.Value==plr then v:Destroy() end end end end end)

f.addCommand({'refresh','re'},{'Refreshes a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr) and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then server:FireClient(plr,'KRefresh') end end end)
f.addCommand({'respawn','spawn'},{'Respawns a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then plr:LoadCharacter() end end end)
f.addCommand({'damage','dmg'},{'Damages a player.','Kohl 1337'},2,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid:TakeDamage(mabs(args[2])) end end end)
f.addCommand({'heal'},{'Heals a player.','Kohl'},2,{'player','number/'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.Health=args[2] and plr.Character.Humanoid.Health+args[2] or plr.Character.Humanoid.MaxHealth end end end)
f.addCommand({'health','hp'},{'Modify a player\'s health.','Kohl 1337'},2,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.MaxHealth=max(1,args[2]) wrap(function() repeat wait() plr.Character.Humanoid.Health=plr.Character.Humanoid.MaxHealth until plr.Character.Humanoid.Health==plr.Character.Humanoid.MaxHealth or plr.Character.Humanoid.Health<=0 end) end end end)
f.addCommand({'speed','spd','walkspeed'},{'Modify a player\'s walkspeed.','Kohl 1337'},2,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.WalkSpeed=f.Auth(pl,plr) and args[2] or max(-9e9,min(9e9,args[2])) end end end)
f.addCommand({'god'},{'Gives a player infinite health.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then local hum,kg,c=plr.Character.Humanoid,new'IntValue'{Parent=plr.Character;Name='KGod'} hum.Health,hum.MaxHealth=math.huge,math.huge c=hum.HealthChanged:connect(function() if not (kg and kg.Parent==plr.Character) then c:disconnect() return end hum.Health,hum.MaxHealth=math.huge,math.huge end) end end end)
f.addCommand({'ungod'},{'Removes god from a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then while FindChild(plr.Character,'KGod') do plr.Character.KGod:Destroy() end local hum=plr.Character.Humanoid wrap(function() repeat wait() hum.MaxHealth,hum.Health=100,100 until hum.MaxHealth==100 and hum.Health==100 end) end end end)
f.addCommand({'ff','forcefield'},{'Gives players a force field.','Kohl'},2,{'player'},function(pl,args)for i,plr in next,args[1] do if (plr and plr.Character) then new'ForceField'{Parent=plr.Character} end end end)
f.addCommand({'unff','unforcefield','unffbomb'},{'Removes force fields from players.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character) then for i2,ff in next,plr.Character:children() do if ff:IsA('ForceField') then ff:Destroy() end end end end end)

f.addCommand({'place','pl'},{'Makes a player teleport places.','Kohl 1337/PrivetServer'},3,{'player','word'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then if tonumber(args[2]) then f.TP(tonumber(args[2]),plr) else local ps,c=DS:GetAsync('KPrivateServers') or {},nil c=ps[args[2]] if c then s.TP:TeleportToPrivateServer(c.Id,c.Code,args[1]) else f.Hint(pl,'No place with that name found!',pl) end end end end end)
f.addCommand({'tp','teleport','tele'},{'Teleports a player to a player.','Kohl me'},2,{'player','player'},function(pl,args) local to=args[2] and args[2][1] for i,plr in next,args[1] do if (plr and plr.Character and plr.Character.PrimaryPart and to and to.Character and to.Character.PrimaryPart) then f.Teleport(plr.Character.PrimaryPart,to.Character.PrimaryPart.CFrame) end end end)
f.addCommand({'to','goto'},{'Teleports a you to a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and plr.Character.PrimaryPart and pl and pl.Character and pl.Character.PrimaryPart) then f.Teleport(pl.Character.PrimaryPart,plr.Character.PrimaryPart.CFrame) end end end)
f.addCommand({'bring'},{'Teleports a player to you.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and plr.Character.PrimaryPart and pl and pl.Character and pl.Character.PrimaryPart) then f.Teleport(plr.Character.PrimaryPart,pl.Character.PrimaryPart.CFrame) end end end)

f.addCommand({'resetstats','rs'},{'Resets the leaderstats of a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and FindChild(plr,'leaderstats')) then for i2,v in next,plr.leaderstats:children() do if not v:IsA'StringValue' then v.Value=Instance.new(v.ClassName).Value end end end end end)
f.addCommand({'change'},{'Modify a stat of a player.','Kohl kills 0'},2,{'player','word','string'},function(pl,args) local filtered = getFilteredMessage(getTextObject(args[3], pl.UserId)) for i,plr in next,args[1] do if (plr and FindChild(plr,'leaderstats')) then for i2,v in next,plr.leaderstats:children() do if v.Name:lower():find('^'..args[2]:lower()) then if v:IsA'StringValue' then v.Value=filtered else v.Value=tonumber(args[3]) end end end end end end)
f.addCommand({'team','tm'},{'Modify the team of a player.','Kohl raiders'},2,{'player','string'},function(pl,args) local tm for i,v in next,s.Teams:children() do if v.Name:lower():find('^'..args[2]:lower()) then tm=v end end for i,plr in next,args[1] do if (plr and plr.Character and tm) then plr.TeamColor=tm.TeamColor end end end)
f.addCommand({'randomizeteams','randomiseteams','randomteams','rteams','rteam','rt'},{'Randomly places players between two teams.','all blue red'},2,{'player','word','word'},function(pl,args) local tm,t1,t2=false for i,v in next,game.Teams:children() do if v.Name:lower():find('^'..args[2]:lower()) then t1=v.TeamColor elseif v.Name:lower():find('^'..args[3]:lower()) then t2=v.TeamColor end end local ntab={} for i,v in next,args[1] do table.insert(ntab,mcel(mran(#ntab+1)),v) end for i,plr in next,ntab do if (plr and t1 and t2) then tm=not tm if tm then plr.TeamColor=t1 else plr.TeamColor=t2 end end end end)

f.addCommand({'music','audio','sound'},{'Plays a sound.','1337'},2,{'number'},function(pl,args) for i,v in next,workspace:children() do if v.Name=='KMusic' then v:Stop() v:Destroy() end end s.Content:Preload('rbxassetid://'..args[1]) while s.Content.RequestQueueSize>0 do wait() end new'Sound'{Parent=s.workspace;Looped=true;Name='KMusic';SoundId='rbxassetid://'..args[1]}:Play() end)
f.addCommand({'stop','stopmusic'},{'Stops a sound.'},2,{},function(pl,args) for i,v in next,workspace:children() do if v.Name=='KMusic' then v:Stop() v:Destroy() end end end)
f.addCommand({'play'},{'Plays a sound.'},3,{},function(pl,args) for i,v in next,workspace:children() do if v.Name=='KMusic' then v:Play() end end end)
f.addCommand({'pause'},{'Pauses a sound.'},3,{},function(pl,args) for i,v in next,workspace:children() do if v.Name=='KMusic' then v:Pause() end end end)
f.addCommand({'pitch'},{'Modify the pitch of a sound.','1337'},2,{'number'},function(pl,args) for i,v in next,workspace:children() do if v.Name=='KMusic' then v.Pitch=args[1] end end end)
f.addCommand({'volume'},{'Modify the volume of a sound.','1337'},2,{'number'},function(pl,args) for i,v in next,workspace:children() do if v.Name=='KMusic' then v.Volume=args[1] end end end)

f.addCommand({'time','tod'},{'Modify the TimeOfDay.','12:30'},2,{'string'},function(pl,args) s.Lighting.TimeOfDay=args[1] end)
f.addCommand({'brightness','bright'},{'Modify the TimeOfDay.','1'},2,{'number'},function(pl,args) s.Lighting.Brightness=args[1] end)
f.addCommand({'ambient'},{'Modify the Ambient.','255 255 255'},2,{'number','number','number'},function(pl,args) s.Lighting.Ambient=c3(args[1]/255,args[2]/255,args[3]/255) end)
f.addCommand({'outdoorambient'},{'Modify the OutdoorAmbient.','255 255 255'},2,{'number','number','number'},function(pl,args) s.Lighting.OutdoorAmbient=c3(args[1]/255,args[2]/255,args[3]/255) end)
f.addCommand({'shadowcolor'},{'Modify the ShadowColor.','255 255 255'},2,{'number','number','number'},function(pl,args) s.Lighting.ShadowColor=c3(args[1]/255,args[2]/255,args[3]/255) end)
f.addCommand({'fogcolor'},{'Modify the FogColor.','255 255 255'},2,{'number','number','number'},function(pl,args) s.Lighting.FogColor=c3(args[1]/255,args[2]/255,args[3]/255) end)
f.addCommand({'fogend'},{'Modify the FogEnd.','1337'},2,{'number'},function(pl,args) s.Lighting.FogEnd=args[1] end)
f.addCommand({'fogstart'},{'Modify the FogStart.','1337'},2,{'number'},function(pl,args) s.Lighting.FogStart=args[1] end)

f.addCommand({'removetools','rtools'},{'Removes all tools from a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then f.rmvTools(plr) end end end)
f.addCommand({'removehats','rhats'},{'Remove a players hats.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character) then for i,v in next,plr.Character:children() do if v:IsA'Accoutrement' then v:Destroy() end end end end end)
f.addCommand({'removelimbs','rlimbs'},{'Remove a players limbs.','Kohl'},2,{'player'},function(pl,args)for i,plr in next,args[1] do if (plr and f.Auth(pl,plr) and plr.Character) then for i,v in next,plr.Character:children() do if v.Name:find(' Leg') or v.Name:find(' Arm') then v:Destroy() end end end end end)
f.addCommand({'removearms','rarms'},{'Remove a players arms.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr) and plr.Character) then for i,v in next,plr.Character:children() do if v.Name:find(' Arm') then v:Destroy() end end end end end)
f.addCommand({'removelegs','rlegs'},{'Remove a players legs.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr) and plr.Character) then for i,v in next,plr.Character:children() do if v.Name:find(' Leg') then v:Destroy() end end end end end)

f.addCommand({'fly'},{'Gives a player flight.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KFly',0) end end end)
f.addCommand({'unfly'},{'Removes a player flight.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KFly') end end end)
f.addCommand({'noclip'},{'Gives a player noclip.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then plr.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam server:FireClient(plr,'KNoclip',0) end end end)
f.addCommand({'clip','unnoclip'},{'Removes a player noclip.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then plr.DevCameraOcclusionMode = s.StarterPlayer.DevCameraOcclusionMode server:FireClient(plr,'KNoclip') end end end)

f.addCommand({'link','connect'},{'Links two players with a line.','Kohl Kensai'},2,{'player','player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then for i2,plr2 in next,args[2] do if (plr2 and plr2.Character and FindChild(plr2.Character,'HumanoidRootPart')) then local pt=new'SelectionPartLasso'{Parent=plr.Character;Color=BrickColor.Random();Name='KLink';Humanoid=plr.Character.Humanoid;Part=plr2.Character.HumanoidRootPart} wrap(function() repeat wait(.1) until not plr or not plr.Character or not FindChild(plr.Character,'Humanoid') or not pt or not pt.Parent or not plr2 or not plr2.Character or not FindChild(plr2.Character,'HumanoidRootPart') pt:Destroy() end) end end end end end)
f.addCommand({'unlink','unconnect'},{'Removes links from a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'KLink')) then repeat plr.Character.KLink:Destroy() until not FindChild(plr.Character,'KLink') end end end)
f.addCommand({'watch','spectate','spy'},{'Watches a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character) then server:FireClient(pl,'KWatch',plr.Character) end end end)
f.addCommand({'unwatch','unspectate','unspy','camfix'},{'Unwatches a player.'},2,{},function(pl,args) server:FireClient(pl,'KWatch') end)
f.addCommand({'fov','fieldofview'},{'Changes a player\'s field of view.','Kohl 1-120'},2,{'player','number'},function(pl,args) for i,plr in next,args[1] do if plr then server:FireClient(plr,'KFOV',args[2]) end end end)

f.addCommand({'lock'},{'Locks a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and f.Auth(pl,plr)) then for i2,v in next,plr.Character:children() do if v:IsA'BasePart' then v.Locked=true elseif FindChild(v,'Handle') then v.Handle.Locked=true end end end end end)
f.addCommand({'unlock'},{'Unlocks a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and f.Auth(pl,plr)) then for i2,v in next,plr.Character:children() do if v:IsA'BasePart' then v.Locked=false elseif FindChild(v,'Handle') then v.Handle.Locked=false end end end end end)
f.addCommand({'punish','oblivion'},{'Punishes a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then new'BodyForce'{Parent=plr.Character.HumanoidRootPart;Name='KPun';force=v3(0,9e9,0);new'Vector3Value'{Name='OP';Value=plr.Character.HumanoidRootPart.Position}} end end end)
f.addCommand({'unpunish','unoblivion'},{'Punishes a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then for i2,v in next,plr.Character.HumanoidRootPart:children() do if v.Name=='KPun' then if FindChild(v,'OP') then f.Teleport(plr.Character.HumanoidRootPart,cf(v.OP.Value)) end v:Destroy() end end end end end)
f.addCommand({'jail','cage'},{'Jails a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then f.rmvTools(plr) local j,jv,j1,j2,j3,j4,j5,j6=new'Model'{Parent=s.workspace;Name='KJail '..plr.Name} jv=plr.Name table.insert(ClearObjects,j) j1=new'Part'{Parent=j;Anchored=true;BrickColor=bc('Really black');Transparency=.2;TopSurface=0;BottomSurface=0;FormFactor=3;Size=v3(6,.2,6);CFrame=plr.Character.HumanoidRootPart.CFrame*cf(0,-2.9,0)} j2=j1:Clone() j2.Parent=j j2.CFrame=j1.CFrame*cf(0,7.2,0) j3=j1:Clone() j3.Parent=j j3.Size=v3(6,7.4,.2) j3.CFrame=(j1.CFrame*cf(0,3.6,2.9)) j4=j3:Clone() j4.Parent=j j4.CFrame=(j1.CFrame*cf(0,3.6,-2.9)) j5=j1:Clone() j5.Parent=j j5.Size=v3(.2,7.4,6) j5.CFrame=(j1.CFrame*cf(2.9,3.6,0)) j6=j5:Clone() j6.Parent=j j6.CFrame=(j1.CFrame*cf(-2.9,3.6,0)) wrap(function() while j and j.Parent==workspace do local p=FindChild(game.Players,jv) if p and p.Character and FindChild(p.Character,'HumanoidRootPart') and (p.Character.HumanoidRootPart.Position-j1.Position).magnitude>6 then f.rmvTools(p) FindChild(p.Character,'HumanoidRootPart').CFrame=j1.CFrame*cf(0,3,0) end wait(.1) end end) end end end)
f.addCommand({'unjail','uncage'},{'Unjails a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then for i,v in next,workspace:children() do if v.Name=='KJail '..plr.Name then v:Destroy() end end end end end)
f.addCommand({'lag','lagify'},{'Lags a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and f.Auth(pl,plr) and not FindChild(plr,'KLag')) then new'IntValue'{Parent=plr;Name='KLag'} server:FireClient(plr,'KLag') end end end)
f.addCommand({'unlag','unlagify'},{'Unlags a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and f.Auth(pl,plr) and FindChild(plr,'KLag')) then plr.KLag:Destroy() end end end)
f.addCommand({'freeze'},{'Freezes a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid') and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr) and not FindChild(plr.Character,'KFreeze')) then plr.Character.Humanoid.WalkSpeed=0 for i,v in next,plr.Character:children() do if v:IsA'BasePart' then v.Anchored=true end end new'Part'{Parent=plr.Character;Name='KFreeze';Anchored=true;TopSurface=0;BottomSurface=0;FormFactor=3;BrickColor=bc('Medium blue');Reflectance=1;Material='Ice';Transparency=.3;Size=v3(5,7,5)}.CFrame=plr.Character.HumanoidRootPart.CFrame+v3(0,.5,0) end end end)
f.addCommand({'thaw','unfreeze'},{'Thaws a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.WalkSpeed=16 for i,v in next,plr.Character:children() do if v:IsA'BasePart' then v.Anchored=false end end if FindChild(plr.Character,'KFreeze') then plr.Character.KFreeze:Destroy() end end end end)
f.addCommand({'blind'},{'Blinds players.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and f.Auth(pl,plr) then server:FireClient(plr,'KBlind',0) end end end)
f.addCommand({'unblind'},{'Unblinds players.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and f.Auth(pl,plr) then server:FireClient(plr,'KBlind') end end end)

f.addCommand({'tshirt'},{'Gives a player a t-shirt.','Kohl 1337'},1,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Torso')) then if FindChild(plr.Character,'Shirt Graphic') then plr.Character['Shirt Graphic'].Parent=plr.Character.Torso end while FindChild(plr.Character,'KTShirt') do plr.Character.KTShirt:Destroy() end new'ShirtGraphic'{Parent=plr.Character;Name='KTShirt';Graphic=getTexture(args[2])} end end end)
f.addCommand({'untshirt'},{'Returns a player\'s t-shirt.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Torso')) then while FindChild(plr.Character,'KTShirt') do plr.Character.KTShirt:Destroy() end if FindChild(plr.Character.Torso,'Shirt Graphic') then plr.Character.Torso['Shirt Graphic'].Parent=plr.Character elseif FindChild(plr.Character.Torso,'roblox') then plr.Character.Torso.roblox.Texture='' end end end end)
f.addCommand({'shirt'},{'Gives a player a shirt.','Kohl 1337'},1,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end while FindChild(plr.Character,'KShirt') do plr.Character.KShirt:Destroy() end new'Shirt'{Parent=plr.Character;Name='KShirt';ShirtTemplate=getTexture(args[2])} end end end)
f.addCommand({'unshirt'},{'Returns a player\'s shirt.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then while FindChild(plr.Character,'KShirt') do plr.Character.KShirt:Destroy() end if FindChild(plr.Character.HumanoidRootPart,'Shirt') then plr.Character.HumanoidRootPart.Shirt.Parent=plr.Character end end end end)
f.addCommand({'pants'},{'Gives a player pants.','Kohl 1337'},1,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end while FindChild(plr.Character,'KPants') do plr.Character.KPants:Destroy() end new'Pants'{Parent=plr.Character;Name='KPants';PantsTemplate=getTexture(args[2])} end end end)
f.addCommand({'unpants'},{'Returns a player\'s pants.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then while FindChild(plr.Character,'KPants') do plr.Character.KPants:Destroy() end if FindChild(plr.Character.HumanoidRootPart,'Pants') then plr.Character.HumanoidRootPart.Pants.Parent=plr.Character end end end end)
f.addCommand({'face'},{'Gives a player a face.','Kohl 1337'},1,{'player','number'},function(pl,args)for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Head') and FindChild(plr.Character,'HumanoidRootPart')) then while FindChild(plr.Character.Head,'KFace') do plr.Character.Head.KFace:Destroy() end if FindChild(plr.Character.Head,'face') then plr.Character.Head.face.Transparency=1 plr.Character.Head.face.Parent=plr.Character.HumanoidRootPart end new'Decal'{Parent=plr.Character.Head,Name='KFace',Texture=getTexture(args[2])} end end end)
f.addCommand({'unface'},{'Returns a player\'s face.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Head') and FindChild(plr.Character,'HumanoidRootPart')) then while FindChild(plr.Character.Head,'KFace') do plr.Character.Head.KFace:Destroy() end if FindChild(plr.Character.HumanoidRootPart,'face') then plr.Character.HumanoidRootPart.face.Parent=plr.Character.Head plr.Character.Head.face.Transparency=0 end end end end)

f.addCommand({'jump'},{'Jumps a player.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.Jump=true end end end)
f.addCommand({'sit'},{'Sits a player.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.Sit=true end end end)
f.addCommand({'unsit'},{'Unsits a player.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.Sit=false end end end)
f.addCommand({'normal'},{'Returns a player to normal.','Kohl'},1,{'player'},f.Normal)

--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
if Set.FunCommands then --|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
--|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

f.addCommand({'clone'},{'Clones a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and plr.Character then plr.Character.Archivable=true local cl=plr.Character:Clone() plr.Character.Archivable=false cl.Parent=game.Workspace cl:MakeJoints() cl:MoveTo(plr.Character:GetModelCFrame().p) table.insert(ClearObjects,cl) end end end)
f.addCommand({'char','character'},{'Modify a player\'s appearance.','Kohl 261'},2,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then plr.CharacterAppearanceId=args[2] plr:LoadCharacter() end end end)
f.addCommand({'unchar','uncharacter'},{'Resets a player\'s.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then plr.CharacterAppearanceId=plr.userId plr:LoadCharacter() end end end)
f.addCommand({'hat'},{'Gives a player a hat.','Kohl 1337'},1,{'player','number'},function(pl,args) local isVIP=mabs(f.getPower(pl))==1 for i,plr in next,args[1] do if (plr and plr.Character) then if isVIP then local n=0 for i,v in next,plr.Character:children() do if v and v.Name=='KHat' then n=n+1 if n>2 then plr.Character.KHat:Destroy() end end end end for i,v in next,s.Insert:LoadAsset(args[2]):children() do if v:IsA'Accoutrement' then if isVIP then local C C=function(a) for _,s in next,a:children() do if s:IsA'Script' or s:IsA'Tool' or s:IsA'HopperBin' or s:IsA'Model' or (s:IsA'BasePart' and s.Name~='Handle') then s:Destroy() end C(s) end end C(v) end v.Name='KHat' v.Parent=plr.Character if isVIP then v.Changed:connect(function() if v then v:Destroy() end end) end end end end end end)
f.addCommand({'gear'},{'Gives a player a gear.','Kohl 1337'},3,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character) then for i2,v2 in next,s.Insert:LoadAsset(args[2]):children() do if v2:IsA('Tool') or v2:IsA('HopperBin') then v2.Parent=plr.Character end end end end end)
f.addCommand({'insert','ins'},{'Inserts a model at the player\'s position.','1337'},3,{'number'},function(pl,args) local imod=s.Insert:LoadAsset(args[1]) imod.Parent=game.Workspace imod:MoveTo(pl.Character:GetModelCFrame().p) imod:MakeJoints() table.insert(ClearObjects,imod) end)

f.addCommand({'disco'},{'Try it out.'},2,{},function(pl,args) if FindChild(script,'KLightEF') then script.KLightEF:Destroy() end local d,c=new'StringValue'{Name='KLightEF';Parent=script} wrap(function() repeat c=c3(mran(255)/255,mran(255)/255,mran(255)/255) s.Lighting.Ambient=c s.Lighting.FogColor=c wait(.1) until not d or d.Parent~=script end) end)
f.addCommand({'flash'},{'Try it out.'},2,{},function(pl,args) if FindChild(script,'KLightEF') then script.KLightEF:Destroy() end local d,c=new'StringValue'{Name='KLightEF';Parent=script} wrap(function() repeat if s.Lighting.Ambient~=c3() then s.Lighting.Brightness=0 c=c3() else s.Lighting.Brightness=5 c=c3(5,5,5) end s.Lighting.Ambient=c s.Lighting.FogColor=c wait(.1) until not d or d.Parent~=script end) end)
f.addCommand({'freaky'},{'SUPER FREAKY.','255 255 255'},2,{'number/','number/','number/'},function(pl,args) s.Lighting.FogColor=c3((args[1] or 255)*-4e4,(args[2] or 255)*-4e4,(args[3] or 255)*-4e4) s.Lighting.FogEnd=9e9 end)

f.addCommand({'invisible','inv'},{'Makes a player invisible.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character) then for i2,v in next,plr.Character:children() do if FindChild(v,'face') then v.face.Parent=plr end if v:IsA'BasePart' then v.Transparency=1 elseif FindChild(v,'Handle') and not v:IsA('Tool') then v.Handle.Transparency=1 elseif FindChild(v,'Head') then v.Head.Transparency=1 end end end end end)
f.addCommand({'visible','vis'},{'Makes a player visible.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character) then for i2,v in next,plr.Character:children() do if FindChild(plr,'face') then plr.face.Parent=v end if v:IsA'BasePart' and not (v.Name=='Head' and FindChild(v.Parent,'KNick',true)) and v.Name~='HumanoidRootPart' then v.Transparency=0 elseif FindChild(v,'Handle') and not v:IsA('Tool') then v.Handle.Transparency=0 elseif FindChild(v,'Head') then v.Head.Transparency=0 end end end end end)

f.addCommand({'explode','ex'},{'Explodes a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then new'Explosion'{Position=plr.Character.HumanoidRootPart.Position;Parent=workspace} end end end)
f.addCommand({'nuke'},{'Nukes a player.','Kohl'},3,{'player'},function(pl,args)for i,plr in next,args[1] do if (plr and plr.Character and plr.Character.PrimaryPart and f.Auth(pl,plr)) then local o,p1,p2=plr.Character.PrimaryPart.CFrame p1=new'Part'{Parent=workspace;TopSurface=0;BottomSurface=0;Anchored=true;CanCollide=false;BrickColor=bc('New Yeller');Transparency=.75;FormFactor=3;Size=v3(1,1,1);CFrame=o} p2=p1:Clone() p2.BrickColor=bc('Really red') local m1,m2=new'SpecialMesh'{Parent=p1;MeshType='Sphere'} m2=m1:Clone() m2.Parent=p2 table.insert(ClearObjects,p1) f.rmv(p1,15) wrap(function() local ex for i=1,333 do wait() i=i*2 m1.Scale=v3(i,i,i) if i==50 then p2.Parent=p1 elseif i>50 then local i=i-50 m2.Scale=v3(i,i,i) end if not ex then new'Explosion'{BlastRadius=i;BlastPressure=9001;Position=o.p;Parent=workspace} end ex=not ex end if p1 then p1:Destroy() end end) end end end)
f.addCommand({'smite'},{'Smites a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and plr.Character.PrimaryPart and f.Auth(pl,plr)) then local pp,s,p1,p2,p3,p4,p5=plr.Character.PrimaryPart.Position-v3(0,3,0),new'Sound'{SoundId='rbxassetid://178090362';Volume=1;Parent=workspace} s:Play() f.rmv(s,7) s,p2=f.CastRay(pp,pp-v3(0,9,0),{plr.Character}) p1=new'Part'{Transparency=.9;Parent=workspace;Material='Neon';FormFactor=3;BrickColor=bc('Institutional white');CanCollide=false;Anchored=true;Size=v3(.2,.2,.2);CFrame=cf((s and p2 or pp)+v3(0,1e3,0));new'BlockMesh'{Scale=v3(10,10000,10)}} p2,p3,p4,p5=p1:Clone(),p1:Clone(),p1:Clone(),p1:Clone() for i,p in next,{p2,p3,p4,p5} do i=i*.1 p.Parent,p.Size=p1,v3(.2+i,.2,.2+i) p.CFrame=p1.CFrame end f.rmv(p1,.5) plr.Character:BreakJoints() end end end)

f.addCommand({'creeper'},{'Creepy..','Kohl'},2,{'player'},function(pl,args) f.Normal(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end local c,t,cf1,cf2,ca1,ca2=plr.Character,plr.Character.Torso,cf(0,-1.5,-.5),cf(0,-1,.5),cfa(0,mrad(90),0),cfa(0,mrad(-90),0) wrap(function() t.Transparency=0 f.LastC0(t) t.Neck.C0=cf(0,1,0)*cfa(mrad(90),mrad(180),0) t['Right Shoulder'].C0=cf1*ca1 t['Left Shoulder'].C0=cf1*ca2 t['Right Hip'].C0=cf2*ca1 t['Left Hip'].C0=cf2*ca2 f.ColorChar(c,'Bright green') end) end end end)
f.addCommand({'uncreeper'},{'Returns a player to normal.','Kohl'},2,{'player'},f.Normal)
f.addCommand({'dog'},{'Makes a player a dog.','Kohl'},2,{'player'},function(pl,args) f.Normal(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end local c,t,ca1,ca2=plr.Character,plr.Character.Torso,cfa(0,mrad(90),0),cfa(0,mrad(-90),0) wrap(function() t.Transparency=1 f.LastC0(t) t.Neck.C0=cf(0,-.5,-2)*cfa(mrad(90),mrad(180),0) t['Right Shoulder'].C0=cf(.5,-1.5,-1.5)*ca1 t['Left Shoulder'].C0=cf(-.5,-1.5,-1.5)*ca2 t['Right Hip'].C0=cf(1.5,-1,1.5)*ca1 t['Left Hip'].C0=cf(-1.5,-1,1.5)*ca2 local st=new'Seat'{Name='KTorso';FormFactor=0;TopSurface=0;BottomSurface=0;Size=v3(3,1,4);new'BodyForce'{force=v3(0,2e3,0)}} st.CFrame=t.CFrame st.Parent=c new'Weld'{Parent=st;Part0=t;Part1=st;C1=cf(0,.5,0)} f.ColorChar(c,'Brown') end) end end end)
f.addCommand({'undog'},{'Returns a player to normal.','Kohl'},2,{'player'},f.Normal)

f.addCommand({'infect'},{'Infects a player.','Kohl'},2,{'player'},f.Infect)
f.addCommand({'uninfect'},{'Returns a player to normal.','Kohl'},2,{'player'},f.Normal)

f.addCommand({'cape'},{'Gives a player a cape.','Kohl red 1337'},1,{'player','color','number/'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character) then if workspace.FilteringEnabled then server:FireAllClients('KCape',{plr.Character,args[2],args[3],0}) else server:FireClient(plr,'KCape',{plr.Character,args[2],args[3],0}) end end end end)
f.addCommand({'uncape'},{'Removes a player\'s cape.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr) then if workspace.FilteringEnabled then server:FireAllClients('KCape',{plr.Character}) else server:FireClient(plr,'KCape',{plr.Character}) end end end end)

f.addCommand({'swagify','swag'},{'Swag.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end new'Shirt'{Name='KShirt';ShirtTemplate='rbxassetid://109163376';Parent=plr.Character} new'Pants'{Name='KPants';PantsTemplate='rbxassetid://109163376';Parent=plr.Character} if workspace.FilteringEnabled then server:FireAllClients('KCape',{plr.Character;c3(1,0,1);109301474}) else server:FireClient(plr,'KCape',{plr.Character;c3(1,0,1);109301474}) end end end end)
f.addCommand({'unswagify','unswag'},{'Returns a player to normal.','Kohl'},1,{'player'},function(pl,args) f.Normal(pl,args) for i,plr in next,args[1] do if (plr) then server:FireClient(plr,'KCape') end end end)
f.addCommand({'blackify','black'},{'Darker than night','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end f.ColorChar(plr.Character,'Really black',0) end end end)
f.addCommand({'unblackify','unblack'},{'Returns a player to normal.','Kohl'},1,{'player'},f.Normal)
f.addCommand({'goldify','gold'},{'Glimmer like gold.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end f.ColorChar(plr.Character,'Gold',0,.4) end end end)
f.addCommand({'ungoldify','ungold'},{'Returns a player to normal.','Kohl'},1,{'player'},f.Normal)
f.addCommand({'shiny','shine'},{'Shine like a diamond.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end f.ColorChar(plr.Character,'Institutional white',0,1) end end end)
f.addCommand({'unshiny','unshine'},{'Returns a player to normal.','Kohl'},1,{'player'},f.Normal)
f.addCommand({'crm'},{'Changes the color/reflection/material of a player.','Kohl pink 1 neon'},1,{'player','color/','number/','word/'},function(pl,args)local a,b,c=args[2] or c3(1,1,1),args[3] or 0,args[4] or 'SmoothPlastic' for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character,'Shirt') then plr.Character.Shirt.Parent=plr.Character.HumanoidRootPart end if FindChild(plr.Character,'Pants') then plr.Character.Pants.Parent=plr.Character.HumanoidRootPart end f.ColorChar(plr.Character,a,0,b,c) end end end)
f.addCommand({'uncrm'},{'Returns a player to normal.','Kohl'},1,{'player'},f.Normal)

f.addCommand({'grav','gravity'},{'Resets a player\'s gravity.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character.HumanoidRootPart,'KGrav')) then plr.Character.HumanoidRootPart.KGrav:Destroy() end end end)
f.addCommand({'setgrav','setgravity','setg'},{'Sets a player\'s gravity.','Kohl 1'},2,{'player','number'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character.HumanoidRootPart,'KGrav') then plr.Character.HumanoidRootPart.KGrav:Destroy() end new'BodyForce'{Parent=plr.Character.HumanoidRootPart;Name='KGrav';force=v3(0,f.getMass(plr.Character)*-args[2]*196.2,0)} end end end)
f.addCommand({'nograv','nog'},{'Removes a player\'s gravity.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character.HumanoidRootPart,'KGrav') then plr.Character.HumanoidRootPart.KGrav:Destroy() end new'BodyForce'{Parent=plr.Character.HumanoidRootPart;Name='KGrav';force=v3(0,f.getMass(plr.Character)*196.2,0)} end end end)
f.addCommand({'skydive','freefall'},{'Skydives a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and plr.Character and plr.Character.PrimaryPart and f.Auth(pl,plr) then plr.Character.PrimaryPart.CFrame=plr.Character.PrimaryPart.CFrame+v3(0,9e3,0) end end end)
f.addCommand({'trip','flip'},{'Trips a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character,'Humanoid') and not plr.Character.Humanoid.Sit and f.Auth(pl,plr)) then plr.Character.HumanoidRootPart.CFrame=plr.Character.HumanoidRootPart.CFrame*cfa(mrad(180),0,0) end end end)
f.addCommand({'fling'},{'Flings a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr) then plr.Character.HumanoidRootPart.CFrame=plr.Character.HumanoidRootPart.CFrame*cfa(mrad(180),0,0) f.rmv(new'BodyForce'{Parent=plr.Character.HumanoidRootPart;force=v3(mran(-3e4,3e4),mran(3e4,5e4),mran(-3e4,3e4))},.3) end end end)
f.addCommand({'loopfling'},{'Loopflings a player.','Kohl'},3,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr) then local t,L=plr.Character.HumanoidRootPart,new'ObjectValue'{Parent=script,Name='Loop';Value=plr} table.insert(ClearObjects,L) wrap(function() repeat if t and t.Parent==plr.Character then t.CFrame=t.CFrame*cfa(mrad(180),0,0) f.rmv(new'BodyForce'{Parent=t;force=v3(mran(-3e4,3e4),mran(3e4,5e4),mran(-3e4,3e4))},.3) wait(2) end until not L or L.Parent~=script end) end end end)
f.addCommand({'unloopfling'},{'Unloopflings a player.','Kohl'},3,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and f.Auth(pl,plr)) then for i,v in next,ClearObjects do if v and v.Name=='Loop' and v.Value==plr then v:Destroy() end end end end end)
f.addCommand({'stun'},{'Stuns a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid') and f.Auth(pl,plr)) then plr.Character.Humanoid.PlatformStand=true end end end)
f.addCommand({'unstun'},{'Unstuns a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid') and f.Auth(pl,plr)) then plr.Character.Humanoid.PlatformStand=false end end end)
f.addCommand({'rocket'},{'Rockets a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then local pt=new'Part'{Parent=plr.Character;Size=v3(1,6,1);Anchored=false;TopSurface=0;BottomSurface=0;new'BodyForce'{force=v3(0,9e3,0)}} new'Weld'{Parent=pt;Part0=pt;Part1=plr.Character.HumanoidRootPart;C1=cf(0,0,1)} wrap(function() wait(5) Instance.new('Explosion',plr.Character).Position=pt.Position plr.Character:BreakJoints() end) end end end)
f.addCommand({'disable'},{'Disables a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then plr.Character.HumanoidRootPart:Destroy() end end end)
f.addCommand({'seizure','seize'},{'Gives a player a seizure.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character,'Humanoid') and f.Auth(pl,plr)) then local t,h,s=plr.Character.HumanoidRootPart,plr.Character.Humanoid t.CFrame=t.CFrame*cfa(mrad(90),0,0) s=new'IntValue'{Parent=plr.Character;Name='KSeizure'} wrap(function() repeat wait() h.PlatformStand=true t.Velocity=v3(mran(-10,10),mran(-5,1),mran(-10,10)) t.RotVelocity=v3(mran(-5,5),mran(-5,5),mran(-5,5)) until not (s and t and h) or s.Parent~=plr.Character if h then h.PlatformStand=false end if s then s:Destroy() end end) end end end)
f.addCommand({'unseizure','unseize'},{'Saves a player from a seizure.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if plr and plr.Character and FindChild(plr.Character,'KSeizure') and f.Auth(pl,plr) then plr.Character.KSeizure:Destroy() end end end)

f.addCommand({'confuse','reverse'},{'Reverses a player\'s walkspeed.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.WalkSpeed=-plr.Character.Humanoid.WalkSpeed end end end)
f.addCommand({'unconfuse','unreverse'},{'Resets a player\'s walkspeed.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Humanoid')) then plr.Character.Humanoid.WalkSpeed=16 end end end)
f.addCommand({'spin'},{'Spins a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then local bg=new'BodyGyro'{Parent=plr.Character.HumanoidRootPart;Name='KSpin';maxTorque=v3(0,math.huge,0);P=1e5;cframe=plr.Character.HumanoidRootPart.CFrame} table.insert(ClearObjects,bg) wrap(function() repeat bg.cframe=bg.cframe*cfa(0,mrad(30),0) wait() until not bg or not bg.Parent end) end end end)
f.addCommand({'unspin'},{'Removes spin from a player.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character.HumanoidRootPart,'KSpin')) then plr.Character.HumanoidRootPart.KSpin:Destroy() end end end)
f.addCommand({'glitch','g'},{'Makes a player glitch.','Kohl 5'},2,{'player','number/'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KGlitch',args[2] or 1) end end end)
f.addCommand({'unglitch','ung'},{'Makes a player stop glitching.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KGlitch') end end end)
f.addCommand({'glitch2','g2'},{'Makes a player glitch2.','Kohl 5'},2,{'player','number/'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KGlitch2',args[2] or 1) end end end)
f.addCommand({'unglitch2','ung2'},{'Makes a player stop glitch2ing.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KGlitch2') end end end)
f.addCommand({'vibrate','vb'},{'Makes a player vibrate.','Kohl 5'},2,{'player','number/'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KVibrate',args[2] or 1) end end end)
f.addCommand({'unvibrate','unvb'},{'Makes a player stop vibrating.','Kohl'},2,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and f.Auth(pl,plr)) then server:FireClient(plr,'KVibrate') end end end)

f.addCommand({'bighead','hugehead','largehead'},{'Gives a player a big head.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Head') and FindChild(plr.Character,'Torso')) then plr.Character.Head.Mesh.Scale=v3(3,3,3) plr.Character.Torso.Neck.C0=cf(0,1.9,0)*cfa(mrad(90),mrad(180),0) end end end)
f.addCommand({'minihead','smallhead','tinyhead','littlehead'},{'Gives a player a mini head.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Head') and FindChild(plr.Character,'Torso')) then plr.Character.Head.Mesh.Scale=v3(.75,.75,.75) plr.Character.Torso.Neck.C0=cf(0,.8,0)*cfa(mrad(90),mrad(180),0) end end end)
f.addCommand({'normalhead'},{'Gives a player a normal head.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Head') and FindChild(plr.Character,'Torso')) then plr.Character.Head.Mesh.Scale=v3(1.25,1.25,1.25) plr.Character.Torso.Neck.C0=cf(0,1,0)*cfa(mrad(90),mrad(180),0) end end end)
f.addCommand({'light','lite','lamp'},{'Gives a player light.','Kohl 5 blue'},1,{'player','number/','color/'},function(pl,args) local isVIP=f.getPower(pl)==1 for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character.HumanoidRootPart,'KLight') then plr.Character.HumanoidRootPart.KLight:Destroy() end new'PointLight'{Parent=plr.Character.HumanoidRootPart;Name='KLight';Range=isVIP and min(10,args[2]) or args[2] or 8;Color=args[3] or c3(1,1,1)} end end end)
f.addCommand({'unlight','unlite','unlamp'},{'Removes a player\'s light.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character.HumanoidRootPart,'KLight')) then plr.Character.HumanoidRootPart.KLight:Destroy() end end end)
f.addCommand({'fire'},{'Gives a player fire.','Kohl 5 black white'},1,{'player','number/','color/','color/'},function(pl,args) local isVIP=f.getPower(pl)==1 for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character.HumanoidRootPart,'KFire') then plr.Character.HumanoidRootPart.KFire:Destroy() end local fire=new'Fire'{Parent=plr.Character.HumanoidRootPart;Name='KFire';Size=(isVIP and min(5,args[2] or 5) or args[2]) or 5} if args[3] then fire.Color,fire.SecondaryColor=args[3],args[4] or args[3] end end end end)
f.addCommand({'unfire'},{'Removes a player\'s fire.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character.HumanoidRootPart,'KFire')) then plr.Character.HumanoidRootPart.KFire:Destroy() end end end)
f.addCommand({'smoke'},{'Gives a player smoke.','Kohl red'},1,{'player','color/'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character.HumanoidRootPart,'KSmoke') then plr.Character.HumanoidRootPart.KSmoke:Destroy() end new'Smoke'{Parent=plr.Character.HumanoidRootPart;Name='KSmoke';Opacity=.1;RiseVelocity=0;Color=args[2] or c3(1,1,1)} end end end)
f.addCommand({'unsmoke'},{'Removes a player\'s smoke.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character.HumanoidRootPart,'KSmoke')) then plr.Character.HumanoidRootPart.KSmoke:Destroy() end end end)
f.addCommand({'sparkles'},{'Gives a player sparkles.','Kohl pink'},1,{'player','color/'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if FindChild(plr.Character.HumanoidRootPart,'KSpark') then plr.Character.HumanoidRootPart.KSpark:Destroy() end new'Sparkles'{Parent=plr.Character.HumanoidRootPart;Name='KSpark';SparkleColor=args[2] or c3(1,1,1)} end end end)
f.addCommand({'unsparkles'},{'Removes a player\'s sparkles.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character.HumanoidRootPart,'KSpark')) then plr.Character.HumanoidRootPart.KSpark:Destroy() end end end)
f.addCommand({'particle','pe'},{'Gives a player a particle.','Kohl 1337 pink'},1,{'player','number/','color/'},function(pl,args) local ex=args[2] or args[3] local nrml=(pl:GetRankInGroup(451053) or 0)<=1 args[2],args[3]=args[2] or nrml and 176111410,args[3] or nrml and c3(1,1,1) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart')) then if not ex and FindChild(plr.Character.HumanoidRootPart,'KPe') then plr.Character.HumanoidRootPart.KPe:Destroy() else if FindChild(plr.Character.HumanoidRootPart,'KPe') then plr.Character.HumanoidRootPart.KPe:Destroy() end local pe=f.pePT:Clone() if args[3] then pe.Color=CS(args[3]) end if args[2] then pe.Texture=getTexture(args[2]) end pe.Name,pe.Enabled='KPe',true pe.Parent=plr.Character.HumanoidRootPart end end end end)
f.addCommand({'unparticle','unpe'},{'Removes a player\'s particle.','Kohl'},1,{'player'},function(pl,args) for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'HumanoidRootPart') and FindChild(plr.Character.HumanoidRootPart,'KPe')) then plr.Character.HumanoidRootPart.KPe:Destroy() end end end)

f.addCommand({'size','resize'},{'Resizes a player.','Kohl 5'},2,{'player','number'},function(pl,args)
for i,plr in next,args[1] do if (plr and plr.Character) then
KSize.ScaleCharacter(plr.Character,min(10,max(.2,args[2]))/plr.Character.HumanoidRootPart.Size.Z,{ResizeModels=true,ScaleTools=true,ScaleHats=true})
end end
end)
f.addCommand({'unsize','unresize'},{'Resets a player\'s size.','Kohl'},2,{'player'},function(pl,args)
for i,plr in next,args[1] do if (plr and plr.Character) then
KSize.ScaleCharacter(plr.Character,1/plr.Character.HumanoidRootPart.Size.Z,{ResizeModels=true,ScaleTools=true,ScaleHats=true})
end end
end)

f.addCommand({'slim'},{'Slims a player.','Kohl'},2,{'player'},function(pl,args)
for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Torso') and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then
local ags={c=plr.Character, t=plr.Character.Torso, r=plr.Character.HumanoidRootPart}
ags.t.Anchored=true ags.t.BottomSurface=0 ags.t.TopSurface=0
local welds={}
for i2,v2 in next,ags.c:children() do
if v2:IsA('BasePart') and v2.Parent.Name~='Infinite' then v2.Anchored=true
elseif v2:IsA('ShirtGraphic') then v2.Parent=ags.t
end
end
local function size(p)
for i2,v2 in next,p:children() do if v2.Parent.Name~='Infinite' then
if (v2:IsA('Weld') or v2:IsA('Motor') or v2:IsA('Motor6D')) and v2.Part1 and v2.Part1.Parent.Name~='Infinite' then
local p1=v2.Part1 p1.Anchored=true v2.Part1=nil
if p1~=FindChild(ags.c,'Head') and p1~=ags.t then
p1.FormFactor=3 p1.Size=v3(p1.Size.X,p1.Size.Y,.2)
elseif p1~=ags.t then p1.Anchored=true
for i3,v3 in next,p1:children() do if v3:IsA('Weld') then v3.Part0=nil v3.Part1.Anchored=true end end
p1.FormFactor=3 p1.Size=v3(p1.Size.X,p1.Size.Y,.2)
for i3,v3 in next,p1:children() do if v3:IsA('Weld') then v3.Part0=p1 v3.Part1.Anchored=false end end
end
if v2.Parent==ags.t then p1.BottomSurface=0 p1.TopSurface=0 end
p1.Anchored=false
v2.Part1=p1
if v2.Part0==ags.t then table.insert(welds,v2) p1.Anchored=true v2.Part0=nil end
elseif v2:IsA('CharacterMesh') then
local bp=tostring(v2.BodyPart):match('%w+.%w+.(%w+)') local msh=Instance.new('SpecialMesh')
if bp and FindChild(ags.c,bp:sub(1,#bp-3)..' '..bp:sub(#bp-2)) then msh.Parent=FindChild(ags.c,bp:sub(1,#bp-3)..' '..bp:sub(#bp-2)) elseif bp and FindChild(ags.c,bp) then msh.Parent=FindChild(ags.c,bp) end
if v2.MeshId and v2.MeshId~=0 then msh.MeshId='http://www.roblox.com/asset/?id='..v2.MeshId end
if v2.BaseTextureId~=0 or v2.BaseTextureId~='0' then msh.TextureId='http://www.roblox.com/asset/?id='..v2.BaseTextureId end
msh.Scale=v3(msh.Scale.X,msh.Scale.Y,.2) v2:Destroy()
elseif v2:IsA('SpecialMesh') and v2.Parent.Name~='Head' then v2.Scale=v3(v2.Scale.X,v2.Scale.Y,.2)
end size(v2)
end end
end
size(ags.c)
ags.t.FormFactor=3
ags.t.Size=v3(ags.t.Size.X,ags.t.Size.Y,.2)
for i2,v2 in next,welds do v2.Part0=ags.t v2.Part1.Anchored=false end
for i2,v2 in next,ags.c:children() do if v2:IsA('BasePart') and v2.Parent.Name~='Infinite' then v2.Anchored=false end end
local weld=new'Weld'{Parent=ags.r;Part0=ags.r;Part1=ags.t;C0=ags.t.Size.Y*2.5<=1.3 and cf(0,-1.3+(ags.t.Size.Y*(3/2)),0) or cf()}
end end
end)

f.addCommand({'unslim'},{'Resets a player\'s slim.','Kohl'},2,{'player'},function(pl,args)
for i,plr in next,args[1] do if (plr and plr.Character and FindChild(plr.Character,'Torso') and FindChild(plr.Character,'HumanoidRootPart') and f.Auth(pl,plr)) then
local ags={c=plr.Character, t=plr.Character.Torso, r=plr.Character.HumanoidRootPart}
ags.t.Anchored=true ags.t.BottomSurface=0 ags.t.TopSurface=0
local welds={}
for i2,v2 in next,ags.t:children() do
if v2:IsA('ShirtGraphic') then v2.Parent=ags.c end
end
for i2,v2 in next,ags.c:children() do
if v2:IsA('BasePart') and v2.Parent.Name~='Infinite' then v2.Anchored=true
end
end
local function size(p)
for i2,v2 in next,p:children() do if v2.Parent.Name~='Infinite' then
if (v2:IsA('Weld') or v2:IsA('Motor') or v2:IsA('Motor6D')) and v2.Part1 and v2.Part1.Parent.Name~='Infinite' then
local p1=v2.Part1 p1.Anchored=true v2.Part1=nil
if p1~=FindChild(ags.c,'Head') and p1~=ags.t then
p1.FormFactor=3 p1.Size=v3(p1.Size.X,p1.Size.Y,1)
elseif p1~=ags.t then p1.Anchored=true
for i3,v3 in next,p1:children() do if v3:IsA('Weld') then v3.Part0=nil v3.Part1.Anchored=true end end
p1.FormFactor=3 p1.Size=v3(p1.Size.X,p1.Size.Y,1)
for i3,v3 in next,p1:children() do if v3:IsA('Weld') then v3.Part0=p1 v3.Part1.Anchored=false end end
end
if v2.Parent==ags.t then p1.BottomSurface=0 p1.TopSurface=0 end
p1.Anchored=false
v2.Part1=p1
if v2.Part0==ags.t then table.insert(welds,v2) p1.Anchored=true v2.Part0=nil end
elseif v2:IsA('CharacterMesh') then
local bp=tostring(v2.BodyPart):match('%w+.%w+.(%w+)') local msh=Instance.new('SpecialMesh')
if bp and FindChild(ags.c,bp:sub(1,#bp-3)..' '..bp:sub(#bp-2)) then msh.Parent=FindChild(ags.c,bp:sub(1,#bp-3)..' '..bp:sub(#bp-2)) elseif bp and FindChild(ags.c,bp) then msh.Parent=FindChild(ags.c,bp) end
if v2.MeshId and v2.MeshId~=0 then msh.MeshId='http://www.roblox.com/asset/?id='..v2.MeshId end
if v2.BaseTextureId~=0 or v2.BaseTextureId~='0' then msh.TextureId='http://www.roblox.com/asset/?id='..v2.BaseTextureId end
msh.Scale=v3(msh.Scale.X,msh.Scale.Y,msh.Scale.X) v2:Destroy()
elseif v2:IsA('SpecialMesh') and v2.Parent.Name~='Head' then v2.Scale=v3(v2.Scale.X,v2.Scale.Y,v2.Scale.X)
end size(v2)
end end
end
size(ags.c)
ags.t.FormFactor=3
ags.t.Size=v3(ags.t.Size.X,ags.t.Size.Y,1)
for i2,v2 in next,welds do v2.Part0=ags.t v2.Part1.Anchored=false end
for i2,v2 in next,ags.c:children() do if v2:IsA('BasePart') and v2.Parent.Name~='Infinite' then v2.Anchored=false end end
local weld=new'Weld'{Parent=ags.r;Part0=ags.r;Part1=ags.t;C0=ags.t.Size.Y*2.5<=1.3 and cf(0,-1.3+(ags.t.Size.Y*(3/2)),0) or cf()}
end end
end)

end
local perms_blacklist = {credit=true, prefix=true, help=true, faq=true, guide=true, info=true}
for i,c in next,s.Commands do for i,n in next,c[1] do i=perms_blacklist[n]~=true and Set.Permissions[n:lower()] if i then c[3]=i end end end
--local function Override(a)for i,v in next,s.Commands do if v[1][1]==a then table.remove(s.Commands,i) end end end
local b,e=wrap(function()for i,v in next,CUSTOM do local nf=v[5] if nf then setfenv(nf,_getenv()) f.addCommand(v[1],{v[2][1],v[2][2]},v[3],v[4],nf) end end end) if not b then print(SN..' Custom Command Error:\t'..e) end
end LoadCommands()

_G.KPrintCmds=function()local a='' for i,v in next,s.Commands do a=a..i..'. '..v[1][1]..' '..(v[2][2] or '')..' - '..v[2][1]..'\n' end print(a) end
banstr.Value=f.AdminS(Bans) admstr.Value=f.AdminS(Admins)

return true