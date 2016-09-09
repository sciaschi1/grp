if SERVER then

	net.Receive("GetJobsServer", function()
		net.Start("GetJobsClient")
			PrintTable(GRolePlay.Jobs)
			net.WriteTable(GRolePlay.Jobs)
		net.Broadcast()
	end)
	
	hook.Add("Initialize", "Create GRolePlay Database", function()
		print("This is doing stuff")
		GRolePlay.DB:Query("CREATE TABLE player_info (Name VARCHAR(50), UID BIGINT(22) NOT NULL")
		GRolePlay.DB:Query("CREATE TABLE grp_player (UID BIGINT(22) NOT NULL , grp_name varchar(50), salary int, money int)")
	end)

	function GRolePlay.Gamemode:GetInfoPly(ply)
		GRolePlay.DB:Query("SELECT * FROM `grp_player` WHERE UID = "..SQLStr(ply:UniqueID())..";", function(Query)
			local data = Query:getData()
			PrintTable(data)
			if data[1] then
				print("[GRolePlay] Found Player, Setting local info")
				GRolePlay.DB:Query("UPDATE `grp_player` SET payday = '25' WHERE UID = "..SQLStr(ply:UniqueID())..";")
				
				GRolePlay.Player.NickName = data[1]["grp_name"]
				GRolePlay.Player.Money = data[1]["money"]
				GRolePlay.Player.Payday = data[1]["salary"]
				PrintTable(GRolePlay.Player)
				net.Start("ChatText")
					net.WriteString(GRolePlay.Player.NickName)
				net.Send(ply)
			else
				print("[GRolePlay] New user! Creating player information")
				GRolePlay.DB:Query("INSERT INTO `grp_player` (UID, grp_name, salary, money) VALUES ("..SQLStr(ply:UniqueID())..", "..SQLStr(ply:Name())..", 25, 0);")
			end
		end)
	end

	function GRolePlay.Gamemode:FindPlayerInDB(ply)
		GRolePlay.DB:Query("SELECT * FROM `grp_player` WHERE UID = "..SQLStr(ply:UniqueID())..";", function(Query)
			local data = Query:getData()
			PrintTable(data)
			if data[1] then
				GRolePlay.Player.NickName = data[1]["grp_name"]
				GRolePlay.Player.Money = data[1]["money"]
				GRolePlay.Player.Payday = data[1]["salary"]
			end
		end)
	end

	function GRolePlay.Gamemode:Payday(ply)
		GRolePlay.Gamemode:FindPlayerInDB(ply)
		
		GRolePlay.DB:Query("UPDATE `grp_player` SET money = money + ".. SQLStr(GRolePlay.Player.Payday) .." WHERE UID ="..SQLStr(ply:UniqueID())..";")
	end
	
	net.Receive("ChangeJob", function()
		print("Got job change from client")
		local ply = net.ReadEntity()
		local teamIndex = net.ReadInt(3)
		
		ply:SetTeam(teamIndex)
		ply:SetModel( GRolePlay.Jobs[ply:Team()]['model'] )
		GRolePlay.DB:Query("UPDATE `grp_player` SET salary = ".. SQLStr(GRolePlay.Jobs[ply:Team()]['salary']) .." WHERE UID ="..SQLStr(ply:UniqueID())..";")
	end)


	timer.Create("Payday", 10,0, function()
		for k,v in pairs( player.GetAll()) do
			GRolePlay.Gamemode:Payday(v)
		end
	end)

	net.Receive("ChangeName", function(length, ply)
		local newname = net.ReadString()
		GRolePlay.DB:Query("UPDATE `grp_player` SET grp_name = '"..newname.."' WHERE UID = "..SQLStr(ply:UniqueID())..";")
		ply:ChatPrint("Name Changed!")
	end)

	hook.Add("PlayerInitialSpawn", "Spawn", function(ply)
		ply:SetTeam(1)
		GRolePlay.Player.NickName = ply:Nick()
		GRolePlay.Gamemode:GetInfoPly(ply)
	end)
end