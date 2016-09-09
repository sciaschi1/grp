//Include Files (Serverside)
AddCSLuaFile("shared.lua")
include("shared.lua")
AddCSLuaFile("client/cl_notifications.lua")
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


