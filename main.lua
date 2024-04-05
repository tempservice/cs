local CONFIG_MESSAGE1 = ""
local CONFIG_MESSAGE2 = ""
local CONFIG_MESSAGE3 = ""
local CONFIG_MESSAGE4 = ""
local CONFIG_MESSAGE5 = ""

repeat task.wait(1) until game:IsLoaded()

local queue = ""
local ServerHopping = false

local SpamChat = function()
	local Messages = {CONFIG_MESSAGE1, CONFIG_MESSAGE2, CONFIG_MESSAGE3, CONFIG_MESSAGE4, CONFIG_MESSAGE5}

	for i = 1, #Messages do
		wait(.15)
		pcall(function()
			game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(Messages[i], "All")
		end)
	end
end

local ServerHop = function()
	queue = queue .. " local CONFIG_MESSAGE1 = `" ..CONFIG_MESSAGE1 .. "`"
	queue = queue .. " local CONFIG_MESSAGE2 = `" ..CONFIG_MESSAGE2 .. "`"
	queue = queue .. " local CONFIG_MESSAGE3 = `" ..CONFIG_MESSAGE3 .. "`"
	queue = queue .. " local CONFIG_MESSAGE4 = `" ..CONFIG_MESSAGE4 .. "`"
	queue = queue .. " local CONFIG_MESSAGE5 = `" ..CONFIG_MESSAGE5 .. "`"
	
	queue = queue .. " loadstring(game:HttpGet('https://dropfarm.vercel.app/script.lua'))()"

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
		end) then ServerHopping = true return end
end

SpamChat()

task.wait(1)

if not ServerHopping then
	repeat 
		task.wait() 
		ServerHop() 
	until ServerHopping
end
