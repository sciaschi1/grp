DeriveGamemode("sandbox")

//Include Clientside Files
AddCSLuaFile("client/cl_jobs.lua")
AddCSLuaFile("client/cl_notifications.lua")
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

//Include Files (Serverside)
include( "shared.lua" )
include("server/_MySQL_.lua")
include("server/db_utils.lua")
include("server/setup.lua")
include("server/ChatAPI.lua")
include("server/utils.lua")
include("server/jobs.lua")

util.AddNetworkString( "ChatText" )
util.AddNetworkString( "ChangeName" )
util.AddNetworkString( "ChangeJob" )
util.AddNetworkString( "GetClient" )
util.AddNetworkString( "GetJobsServer" )
util.AddNetworkString( "GetJobsClient" )


local weapons = {
"weapon_physcannon",
"weapon_physgun",
"gmod_tool",
"gmod_camera",
}

hook.Add("PlayerLoadout","RestrictWeapons",function(ply)
	for _,v in ipairs(weapons) do ply:Give(v) end
	return true
end)

/*
function GM:EntityTakeDamage( target, d )
	local attacker, inflictor, damage, type = d:GetAttacker(), d:GetInflictor(), d:GetDamage(), d:GetDamageType()
	local propdmg = string.find(string.lower(tostring(d:GetAttacker())), "prop_")
	
	if (target:IsPlayer() and propdmg >= 1) then 
		return true 
	elseif(	propdmg < 0 ) then
		return false
	end
end
*/