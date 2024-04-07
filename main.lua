repeat task.wait(1) until game:IsLoaded()

if getgenv().Loaded ~= nil then return end

getgenv().Loaded = true

local queue = ""
local ServerHopping = false

local SpamChat = function()
	local Messages = {
		",gg/7BUmSSrWgb CH$AP CARS!!",
		",gg/7BUmSSrWgb TORP GIVEAWAYS!!",
		",gg/7BUmSSrWgb CH$AP ITEMS!!!",
		",gg/7BUmSSrWgb CH$AP HYPERS!!!",
		",gg/7BUmSSrWgb CH$AP AUTOFARMS!!!",
	}

	for i = 1, #Messages do
		task.wait(.15)
		pcall(function()
			game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(Messages[i], "All")
		end)
	end
end

local ServerHop = function()
	queue = queue .. " loadstring(game:HttpGet('https://raw.githubusercontent.com/tempservice/cs/main/main.lua'))()"

	if syn then
		syn.queue_on_teleport(queue)
	else
		queue_on_teleport(queue)
	end

	local PlaceID = game.PlaceId
	local AllIDs = {}
	local foundAnything = ""
	local actualHour = os.date("!*t").hour
	local Deleted = false
	local File = pcall(function()
		AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
	end)
	if not File then
		table.insert(AllIDs, actualHour)
		writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
	end
	function TPReturner()
		local Site;
		if foundAnything == "" then
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
		else
			Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
		end
		local ID = ""
		if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
			foundAnything = Site.nextPageCursor
		end
		local num = 0;
		for i,v in pairs(Site.data) do
			local Possible = true
			ID = tostring(v.id)
			if tonumber(v.playing) <= 5 then
				for _,Existing in pairs(AllIDs) do
					if num ~= 0 then
						if ID == tostring(Existing) then
							Possible = false
						end
					else
						if tonumber(actualHour) ~= tonumber(Existing) then
							local delFile = pcall(function()
								delfile("NotSameServers.json")
								AllIDs = {}
								table.insert(AllIDs, actualHour)
							end)
						end
					end
					num = num + 1
				end
				if Possible == true then
					table.insert(AllIDs, ID)
					wait()
					pcall(function()
						writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
						wait()
						game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
					end)
					wait(2.25)
				end
			end
		end
	end

	function TeleportSmall()
		while wait() do
			pcall(function()
				TPReturner()
				if foundAnything ~= "" then
					TPReturner()
				end
			end)
		end
	end

	if pcall(function()
			TeleportSmall()
		end) then ServerHopping = true return end
end

for i = 0, 1 do
	SpamChat()
end

task.wait(1)

if not ServerHopping then
	repeat 
		task.wait() 
		ServerHop() 
	until ServerHopping and game:GetService("Players").LocalPlayer == nil
end
