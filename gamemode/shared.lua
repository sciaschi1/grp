GM.Name = "GWorlds | GRolePlay"
GM.Author = "(DJ)Led Zeppelin"
GM.Email = "sciaschi@gmail.com"
GM.Website = "gworlds.net"
GM.Version = "1"

local NickName

net.Receive("ChatText", function()
	NickName = net.ReadString()
end)

function GM:OnPlayerChat( ply, strText)
	chat.AddText(team.GetColor(ply:Team()), NickName, Color( 255, 255, 255 ), ": ", strText )
	return true
end
