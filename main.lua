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

	local Http = game:GetService("HttpService")
	local TPS = game:GetService("TeleportService")
	local Api = "https://games.roblox.com/v1/games/"

	local _place = game.PlaceId
	local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"

	function ListServers(cursor)
		local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
		return Http:JSONDecode(Raw)
	end

	local Server, Next; repeat
		local Servers = ListServers(Next)
		Server = Servers.data[1]
		Next = Servers.nextPageCursor
	until Server

	if pcall(function()
			TPS:TeleportToPlaceInstance(_place,Server.id,game:GetService("Players").LocalPlayer)				
		end) and not game:GetService("Players").LocalPlayer then ServerHopping = true return end
end

for i = 1, 1 do
	SpamChat()
end

task.wait(1)

if not ServerHopping then
	repeat 
		task.wait() 
		ServerHop() 
	until ServerHopping and game:GetService("Players").LocalPlayer == nil
end
