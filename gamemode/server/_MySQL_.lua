require("mysqloo")

DATABASE = {}
DATABASE.Object = nil

function DATABASE:Query(command, callback)

	if !DATABASE.Object then return end
	local query = DATABASE.Object:query(command)
	query.onSuccess = callback
	query.onError = function()
		print(command)
		if DATABASE.Object:status() ~= mysqloo.DATABASE_CONNECTED then
			DATABASE.Object:connect()
			DATABASE.Object:wait()
			if DATABASE.Object:status() ~= mysqloo.DATABASE_CONNECTED then
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

	DATABASE.Object = mysqloo.connect("localhost", "root", "killer", "groleplay")
	DATABASE.Object.onConnected = function()
		print("Connected to database.")
	end
	DATABASE.Object.onConnectionFailed = function()
		print("Connection could not be established!")
	end
	DATABASE.Object:connect()

end)