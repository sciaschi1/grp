include( "setup.lua" )
require( "mysqloo" )

GRolePlay.DB = {}
GRolePlay.DB.Object = nil

function GRolePlay.DB:Query(command, callback)

	if !GRolePlay.DB.Object then return end
	local query = GRolePlay.DB.Object:query(command)
	query.onSuccess = callback
	query.onError = function()
		print(command)
		if GRolePlay.DB.Object:status() ~= mysqloo.DATABASE_CONNECTED then
			GRolePlay.DB.Object:connect()
			GRolePlay.DB.Object:wait()
			if GRolePlay.DB.Object:status() ~= mysqloo.DATABASE_CONNECTED then
				ErrorNoHalt("Re-connection to database server failed.")
				return
			else
				query:start()
			end
		end
	end
	query:start()
	
end

hook.Add("Initialize", "ConnectDatabase", function()

	GRolePlay.DB.Object = mysqloo.connect("185.38.149.155", "technofo_sean", "K1ll3r12", "technofo_groleplay")
	GRolePlay.DB.Object.onConnected = function()
		print("Connected to database.")
	end
	GRolePlay.DB.Object.onConnectionFailed = function()
		print("Connection could not be established!")
		GRolePlay.DB.Object:connect()
	end
	GRolePlay.DB.Object:connect()

end)

