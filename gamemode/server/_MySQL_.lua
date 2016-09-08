require( "mysqloo" )

local queue = {} 
local GRolePlay.DB = mysqloo.connect( "185.38.149.155", "technofo_sean", "K1ll3r12", "technofo_groleplay", 3306 )
 
function GRolePlay.DB:onConnected()
	print( "[GRolePlay] Connection to database succeeded!" )
	for k, v in pairs( queue ) do

		query( v[ 1 ], v[ 2 ] )

	end
	queue = {}

end
 
function GRolePlay.DB:onConnectionFailed( err )
 
    print( "[GRolePlay] Connection to database failed!" )
    print( "Error:", err )
 
end
 
GRolePlay.DB:connect()

function query( sql, callback )

	local q = GRolePlay.DB:query( sql )
	function q:onSuccess( data )
	
		callback( data )

	end

	function q:onError( err )

		if GRolePlay.DB:status() == mysqloo.DATABASE_NOT_CONNECTED then
			print( "[GRolePlay] MySQL Server has gone away! Trying to reconnect" )
			table.insert( queue, { sql, callback } )
			GRolePlay.DB:connect()
			return
		end

		print( "Query Errored, error:", err, " sql: ", sql )

	end

	q:start()

end