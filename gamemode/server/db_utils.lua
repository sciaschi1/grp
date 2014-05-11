util.AddNetworkString( "ChatText" )
util.AddNetworkString( "ChangeName" )
util.AddNetworkString( "GetClient" )

GRolePlay = {}
function GRolePlay:Setup(ply)
	DATABASE:Query("INSERT INTO `user` (id,steam_name,steam_id,game_name,Cash,payday,job) VALUES (NULL, '"..ply:Name().."', '"..ply:SteamID().."', '"..ply.NickName.."', 0, 100, 'Commoner');", function(ply)
		ply.NickName = ply:Nick()
	end)
end

function GRolePlay:GetCashandNick(ply)
		DATABASE:Query(string.format("SELECT * FROM `user` WHERE steam_id = '"..ply:SteamID().."'"), function(query)
			local data = query:getData()
			if data[1] then
				ply.NickName = data[1]["game_name"]
				ply.Cash = data[1]["Cash"]
				ply.Payday = data[1]["payday"]
				ply.Job = data[1]["job"]
				net.Start("ChatText")
					net.WriteString(ply.NickName)
				net.Send(ply)
			end
		end)
end

function GRolePlay:GetPayday(ply)
	return ply.Payday
end

function GRolePlay:Payday(ply)
	for _,ply in pairs( player.GetAll() ) do
		DATABASE:Query("UPDATE `user` SET Cash = '".. (ply.Cash + ply.Payday) .."' WHERE game_name ='"..ply.NickName.."';")
	end
end

timer.Create("GetCash", 1,0, function()
	for k,v in pairs( player.GetAll() ) do
		GRolePlay:GetCashandNick(v)
	end
end)

timer.Create("Payday", 20,0, function()
	print("Working")
	for k,v in pairs( player.GetAll() ) do
		
	end
end)

net.Receive("ChangeName", function(length, ply)
	local newname = net.ReadString()
	DATABASE:Query("UPDATE `user` SET game_name = '"..newname.."' WHERE game_name ='"..ply.NickName.."';")
	ply:ChatPrint("Name Changed!")
end)


hook.Add("PlayerInitialSpawn", "Spawn", function(ply)
	ply.NickName = ply:Nick()
	DATABASE:Query(string.format("SELECT * FROM `user` WHERE steam_id = '"..ply:SteamID().."'"), function(query)
			local data = query:getData()
			if data[1] then
				ply.NickName = data[1]["game_name"]
				ply.Cash = data[1]["Cash"]
				ply.Payday = data[1]["payday"]
				ply.Job = data[1]["job"]
				net.Start("ChatText")
					net.WriteString(ply.NickName)
				net.Send(ply)
			else
				GRolePlay:Setup(ply)
			end
		end)
	DATABASE:Query(string.format("SELECT * FROM `user_settings`"), function(query)
			local data = query:getData()
			ply.RunSpeed = data[1]["runspeed"]
			ply.WalkSpeed = data[1]["walkspeed"]
		end)
end)