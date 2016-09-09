//AddCSLuaFiles (Clientside)
AddCSLuaFile("shared.lua")
AddCSLuaFile("client/cl_jobs.lua")
//

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

function JobMenu()
	local DermaPanel = vgui.Create( "DFrame" )
		  DermaPanel:SetPos( 100, 100 )
		  DermaPanel:SetSize( 300, 200 )
		  DermaPanel:SetTitle( "My new Derma frame" )
		  DermaPanel:SetDraggable( true )
		  DermaPanel:MakePopup()
		  
	net.Start("GetJobsServer")
		net.WriteString("Send")
	net.SendToServer()
	
	net.Receive("GetJobsClient", function()
		print("did stuff")
		local Jobs = net.ReadTable()
		local grid = vgui.Create( "DGrid", DermaPanel )
		  grid:SetPos( 10, 30 )
		  grid:SetCols( 5 )
		  grid:SetColWide( 36 )
	
		for i = 1, #Jobs do
			print(Jobs[i]['name'])
			local but = vgui.Create( "DButton" )
			but:SetText( Jobs[i]['name'])
			but:SetSize( 30, 20 )
			but.DoClick = function(ply)
				net.Start("ChangeJob")
					net.WriteEntity(LocalPlayer())
					print(i .. " is the index. SO DONT TELL ME IT DOESNT EXIST")
					net.WriteInt(i, 3)
				net.SendToServer()
				
			end
			grid:AddItem( but )
		end
	end)
	
	
		  
	
end
concommand.Add("OpenJobMenu", JobMenu)