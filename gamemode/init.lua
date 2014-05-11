//AddCSLuaFiles (Clientside)
AddCSLuaFile("shared.lua")
//

//Include Files (Serverside)
include("shared.lua")
include("server/_MySQL_.lua")
include("server/db_utils.lua")
include("server/ChatAPI.lua")

util.AddNetworkString( "ChatText" )
util.AddNetworkString( "ChangeName" )
util.AddNetworkString( "GetClient" )
util.AddNetworkString( "NewJob" )

RegisterChatCommand("!changename", function(ply, args)
		local pname = args[1];

		for _, v in pairs( player.GetAll() ) do
			if( string.find(v:Nick(), pname) ) then
				v:ConCommand("ChangeName");
			end
		end
end)

RegisterChatCommand("!job", function(ply, args)
		local pname = args[1];
		local job = args[2];
		if( string.find(ply:Nick(), pname) ) then
			if((job == "Commoner") || (job == "commoner")) then
				ply:SetTeam(1)
				DATABASE:Query("UPDATE `user` SET job = '".. job .."' WHERE game_name ='"..ply.NickName.."';")
			elseif ((job == "Police") || (job == "police")) then
				ply:SetTeam(2)
				DATABASE:Query("UPDATE `user` SET job = '".. job .."' WHERE game_name ='"..ply.NickName.."';")
			elseif ((job == "Mayor") || (job == "mayor")) then
				ply:SetTeam(3)
				DATABASE:Query("UPDATE `user` SET job = '".. job .."' WHERE game_name ='"..ply.NickName.."';")
			else
				DATABASE:Query("UPDATE `user` SET job = '".. job .."' WHERE game_name ='"..ply.NickName.."';")
			end
			DATABASE:Query("UPDATE `user` SET job = '".. job .."' WHERE game_name ='"..ply.NickName.."';")
		end
end)

