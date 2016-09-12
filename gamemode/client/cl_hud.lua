local hide = {
	CHudHealth = true,
	CHudBattery = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	
	if ( hide[ name ] ) then return false end
	-- Don't return anything here, it may break other addons that rely on this hook.
end )

hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()
	draw.RoundedBox( 0, 0, ScrH() - 128, 250, 128, Color( 255, 255, 255, 255 ) ) -- Draw a box
	draw.RoundedBox( 0, 0, ScrH() - 128, 250, 20, Color(52, 152, 219) ) -- Draw a box

			local icon = vgui.Create( "DModelPanel")
			icon:SetPos(0, ScrH() - 128)
			icon:SetSize( 100, 100 )
			icon:SetModel( LocalPlayer():GetModel() ) -- you can only change colors on playermodels
			function icon:LayoutEntity( Entity ) return end -- disables default rotation
			function icon.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.

			local eyepos = icon.Entity:GetBonePosition( icon.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )

			eyepos:Add( Vector( 0, 0, 2 ) )	-- Move up slightly

			icon:SetLookAt( eyepos )

			icon:SetCamPos( eyepos-Vector( -15, 0, 0 ) )	-- Move cam in front of eyes

			icon.Entity:SetEyeTarget( eyepos-Vector( -12, 0, 0 ) )
				

end )