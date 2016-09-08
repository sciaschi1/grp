function JobMenu()
	local DermaPanel = vgui.Create( "DFrame" )
		  DermaPanel:SetPos( 100, 100 )
		  DermaPanel:SetSize( 300, 200 )
		  DermaPanel:SetTitle( "My new Derma frame" )
		  DermaPanel:SetDraggable( true )
		  DermaPanel:MakePopup()
		  
	local grid = vgui.Create( "DGrid", DermaPanel )
		  grid:SetPos( 10, 30 )
		  grid:SetCols( 5 )
		  grid:SetColWide( 36 )
	
	for i = 0, #GRolePlay.Jobs do
		print(GRolePlay.Jobs[i])
		local but = vgui.Create( "DButton" )
		but:SetText( GRolePlay.Jobs[i - 1])
		but:SetSize( 30, 20 )
		grid:AddItem( but )
	end
end
concommand.Add("OpenJobMenu", JobMenu)