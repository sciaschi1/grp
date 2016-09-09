AddCSLuaFile("client/cl_notifications.lua")
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
		  DermaPanel:SetPos(ScrW() / 2, ScrH() / 2)
		  DermaPanel:SetSize( 500, 500 )
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
		  grid:SetColWide( 55 )
		  grid:SetRowHeight( 55 ) 
	
		for i = 1, #Jobs do
			print(Jobs[i]['name'])
			/*
			local but = vgui.Create( "DButton" )
			but:SetText("")
			but:SetSize( 50, 50 )
			but.DoClick = function(ply)
				net.Start("ChangeJob")
					net.WriteEntity(LocalPlayer())
					print(i .. " is the index. SO DONT TELL ME IT DOESNT EXIST")
					net.WriteInt(i, 3)
				net.SendToServer()
			end
			but.Paint = function(self, w, h)
				draw.RoundedBox(2, 0, 0, w + 5, h + 5, Color(220,220,220) )
			end
			*/
			local Panel = vgui.Create( "DPanel" )
			Panel:SetSize( 50, 50 )

			local icon = vgui.Create( "DModelPanel", Panel )
			icon:SetSize( 50, 50 )
			icon:SetModel( GRolePlay.Jobs[i]['model'] ) -- you can only change colors on playermodels
			function icon:LayoutEntity( Entity ) return end -- disables default rotation
			function icon.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.

			local eyepos = icon.Entity:GetBonePosition( icon.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )

			eyepos:Add( Vector( 0, 0, 2 ) )	-- Move up slightly

			icon:SetLookAt( eyepos )

			icon:SetCamPos( eyepos-Vector( -15, 0, 0 ) )	-- Move cam in front of eyes

			icon.Entity:SetEyeTarget( eyepos-Vector( -12, 0, 0 ) )
			
			function icon:OnMousePressed( keyCode )
				net.Start("ChangeJob")
					net.WriteEntity(LocalPlayer())
					print(i .. " is the index. SO DONT TELL ME IT DOESNT EXIST")
					net.WriteInt(i, 3)
				net.SendToServer()
				local vPoint = LocalPlayer():GetPos() + Vector(0,0,80)
				local effectdata = EffectData()
				effectdata:SetStart(vPoint) -- Not sure if we need a start and origin (endpoint) for this effect, but whatever
				effectdata:SetOrigin(vPoint)
				effectdata:SetScale(1)
				util.Effect("ManHackSparks", effectdata)
				EmitSound( Sound( "garrysmod/balloon_pop_cute.wav" ), LocalPlayer():GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
				notification.AddLegacy("You changed your job to " .. Jobs[i]['name'], NOTIFY_GENERIC, 5)
				DermaPanel:Close()
			end
			
			grid:AddItem( Panel )
		end
	end)
	
	
	
end
concommand.Add("OpenJobMenu", JobMenu)

