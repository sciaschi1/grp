function JobMenu()
	//Instantiate the parent menu
	local DermaPanel = vgui.Create( "DFrame" )
		  local screenw = ScrW() / 2
		  local screenh = ScrH() / 2
		  DermaPanel:SetPos(screenw-500, screenh-300)
		  DermaPanel:SetSize( 1000, 600 )
		  DermaPanel:SetTitle( "" )
		  DermaPanel:SetDraggable( false )
		  DermaPanel:ShowCloseButton(false)
		  DermaPanel:MakePopup()
		  DermaPanel.Paint = function(self, w, h)
			  draw.RoundedBox(2, 0, 0, w, h, Color(220,220,220) )
		  end
		 
	//Instantiate the panel for the tab buttons. makes it seperate from the 
	local TabPanel = vgui.Create( "DPanel", DermaPanel )	
	TabPanel:SetPos( 0, 0 ) -- Set the position of the panel
	TabPanel:SetSize( 200, DermaPanel:GetTall()) -- Set the size of the panel
	
	local jobDesc
	//Instantiate the jobs tab panel
	local JobsTab = vgui.Create( "DPanel", DermaPanel )
	JobsTab:SetPos( -800, 0 ) -- Set the position of the panel
	JobsTab:SetSize( 800, DermaPanel:GetTall() ) -- Set the size of the panel
	JobsTab:MoveTo( 200, 0, 0.2, 0, 1)
	JobsTab.Paint = function( self, w, h ) 
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 128, 255 ) ) 
	end
	
	local JobsDescLabel = vgui.Create("DLabel", JobsTab)
	JobsDescLabel:SetPos(JobsTab:GetWide() - 150, JobsTab:GetTall() - 120)
	JobsDescLabel:SizeToContents()
	
	
	//Instantiate the jobs button
	local JobsTabButton = vgui.Create( "DButton", TabPanel )
		JobsTabButton:SetText( "" )				 // Set the text on the button
		JobsTabButton:SetPos( 0, 0 )					// Set the position on the frame
		JobsTabButton:SetSize( TabPanel:GetWide(), 80 )				 // Set the size
		JobsTabButton.DoClick = function(self, w, h)
			JobsTab:MoveTo( 200, 0, 0.2, 0, 1)
		end
		JobsTabButton.Paint = function( self, w, h ) 
			draw.RoundedBox( 0, 0, 0, w, h, Color(41, 128, 185) )
			draw.DrawText( "Jobs", "GRolePlayButtonFont", w / 2, (h / 2) - 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		end
	
	//Get the jobs from the server call
	net.Start("GetJobsServer")
		net.WriteString("Send")
	net.SendToServer()
	
	net.Receive("GetJobsClient", function()
		//Get jobs from server since its clunky via clientside only
		local Jobs = net.ReadTable()
		
		//Create scrollbar so that there can be a ton of jobs
		local IconsPanel = vgui.Create( "DScrollPanel", JobsTab )
		IconsPanel:SetPos( 0, 0 )
		IconsPanel:SetSize( 350, DermaPanel:GetTall() )
		
		//Paint the Scroll Panel scrollbar
		local sbar = IconsPanel:GetVBar()
		function sbar:Paint( w, h )
			draw.RoundedBox( 6, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
		end
		function sbar.btnUp:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0 , 0) )
		end
		function sbar.btnDown:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(  0, 0, 0 , 0) )
		end
		function sbar.btnGrip:Paint( w, h )
			draw.RoundedBox( 6, 0, 0, w, h, Color(0, 0, 0 , 150 ) )
		end

		//Set up grid for jobs
		local grid = vgui.Create( "DGrid", IconsPanel )
		  grid:SetPos( 10, 30 )
		  grid:SetCols( 3 )
		  grid:SetColWide( 105 )
		  grid:SetRowHeight( 105 ) 
	
		//Get all Jobs and make icons based on the job
		for i = 1, #Jobs do
		
			//Set up panel for job model
			local Panel = vgui.Create( "DPanel" )
			Panel:SetSize( 100, 100 )

			// Player Icon for Job
			local icon = vgui.Create( "DModelPanel", Panel )
			icon:SetSize( 100, 100 )
			icon:SetModel( Jobs[i]['model'] ) -- you can only change colors on playermodels
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
			
			function icon:OnCursorEntered()
				JobsDescLabel:SetText(Jobs[i]['description'])
			end
			
			function icon:OnCursorExited()
				JobsDescLabel:SetText("")
			end
			
			
			grid:AddItem( Panel )
		end
	end)
end
concommand.Add("OpenJobMenu", JobMenu)