util.AddNetworkString( "ChatText" )
util.AddNetworkString( "ChangeName" )
util.AddNetworkString( "GetClient" )

function GRolePlay.DB.CreateDatabase()
	GRolePlay.DB:Query("CREATE TABLE IF NOT EXISTS player_info (Name VARCHAR(50), UID NOT NULL int)")
	GRolePlay.DB:Query("CREATE TABLE IF NOT EXISTS grp_player  (UID NOT NULL bigint(20), grp_name varchar(50), salary int, money int)")
end

function GRolePlay:GetInfoPly(ply)
	GRolePlay.DB:Query("SELECT * FROM `user` WHERE steam_id = "..SQLStr(ply:SteamID())..";", function(query)
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
			GRolePlay.DB:Query("INSERT INTO `user` (id,steam_name,steam_id,game_name,Cash,payday,job) VALUES (NULL, "..SQLStr(ply:Name())..", "..SQLStr(ply:SteamID())..", "..SQLStr(ply.NickName)..", 0, 100, 'Commoner');", function(ply)
			end)
		end
	end)
end

function GRolePlay:GetPayday(ply)
	return ply.Payday
end

function GRolePlay:Payday(ply)
	for _,ply in pairs( player.GetAll() ) do
		GRolePlay.DB:Query("UPDATE `user` SET Cash = '".. (ply.Cash + ply.Payday) .."' WHERE game_name ="..SQLStr(ply.NickName)..";")
	end
end

timer.Create("GetCash", 1,0, function()
	for k,v in pairs( player.GetAll() ) do
		GRolePlay:GetInfoPly(v)
	end
end)

timer.Create("Payday", 4,0, function()
	for k,v in pairs( player.GetAll() ) do
		GRolePlay:Payday(v)
	end
end)

net.Receive("ChangeName", function(length, ply)
	local newname = net.ReadString()
	GRolePlay.DB:Query("UPDATE `user` SET game_name = '"..newname.."' WHERE game_name = "..SQLStr(ply.NickName)..";")
	ply:ChatPrint("Name Changed!")
end)

hook.Add("PlayerSpawn", "CheckSpawn", function(ply)

	if((ply.Job == "Commoner")) then
		ply:SetTeam(1)
		GRolePlay.DB:Query("UPDATE `user` SET payday = '100' WHERE game_name = "..SQLStr(ply.NickName)..";")
	elseif ((ply.Job == "Police")) then
		ply:SetTeam(2)
		GRolePlay.DB:Query("UPDATE `user` SET payday = '500' WHERE game_name = "..SQLStr(ply.NickName)..";")
	elseif ((ply.Job == "Mayor")) then
		ply:SetTeam(3)
		GRolePlay.DB:Query("UPDATE `user` SET payday = '1000' WHERE game_name = "..SQLStr(ply.NickName)..";")
	end

end)

hook.Add("PlayerInitialSpawn", "Spawn", function(ply)
	ply:SetTeam(1)
	ply.NickName = ply:Nick()
	GRolePlay.DB:Query("UPDATE `user` SET payday = '100' WHERE game_name = "..SQLStr(ply.NickName)..";")
	GRolePlay.DB:Query("UPDATE `user` SET job = 'Commoner' WHERE game_name = "..SQLStr(ply.NickName)..";")
	GRolePlay.DB:Query(string.format("SELECT * FROM `user` WHERE steam_id = "..SQLStr(ply:SteamID())..";"), function(query)
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
	GRolePlay.DB:Query(string.format("SELECT * FROM `user_settings`"), function(query)
			local data = query:getData()
			ply:SetRunSpeed(data[1]["runspeed"])
			ply:SetWalkSpeed(data[1]["walkspeed"])
		end)
end)