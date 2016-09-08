//AddCSLuaFiles (Clientside)
AddCSLuaFile("shared.lua")
//

//Include Files (Serverside)
include("shared.lua")
include("server/_MySQL_.lua")
include("server/db_utils.lua")
include("server/setup.lua")
include("server/ChatAPI.lua")
include("server/utils.lua")
include("server/jobs.lua")

util.AddNetworkString( "ChatText" )
util.AddNetworkString( "ChangeName" )
util.AddNetworkString( "GetClient" )
util.AddNetworkString( "NewJob" )

