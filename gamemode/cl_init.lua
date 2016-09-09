DeriveGamemode("sandbox")

//Includes
AddCSLuaFile("client/cl_notifications.lua")
AddCSLuaFile("client/cl_jobs.lua")
include("init.lua")

timer.Create("GetClient", 1, 0, function()
	net.Start("GetClient")
		net.WriteEntity(LocalPlayer())
	net.SendToServer()
end)



function ChangeMyName(ply)
	local mainframe = vgui.Create("DFrame")
	mainframe:SetSize(250,100)
	mainframe:SetTitle("Name Change")
	mainframe:Center()
	mainframe:SetBackgroundBlur( true )
	mainframe:MakePopup()
	
	local NameText = vgui.Create("DLabel", mainframe)
	NameText:SetText("New Name: ")
	NameText:SetPos(5,35)
	
	local NameTextArea = vgui.Create("DTextEntry", mainframe)
	NameTextArea:SetWidth(150)
	NameTextArea:SetPos(70,35)
	
	local SubmitBtn = vgui.Create("DButton", mainframe)
	SubmitBtn:SetText("Submit")
	SubmitBtn:SetWidth(mainframe:GetWide() - 10)
	SubmitBtn:SetPos(5,75)
	SubmitBtn.DoClick = function(ply)
		name = NameTextArea:GetValue()
		net.Start("ChangeName")
			net.WriteString(name)
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
	end
end
concommand.Add("ChangeName",ChangeMyName)



