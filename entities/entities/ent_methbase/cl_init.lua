include("shared.lua")

function ENT:Draw()
    //self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
	if self:GetPos():Distance(LocalPlayer():GetPos()) < 500 then -- How far people can see printer UI
			
		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Forward(), 90)
		
		cam.Start3D2D(Pos + Ang:Up() * 15+ Ang:Forward() * -20 + Ang:Right() * -25, Ang, 0.11)
			draw.RoundedBox( 0, 0, 0, 400, 275, Color(20,20,20,255) )
			surface.DrawOutlinedRect( 0, 0, 275, 275 )
			surface.DrawOutlinedRect( 1, 1, 273, 273 )
			draw.SimpleText( "Ingredients Needed", "GRolePlayButtonFont", 15, 15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
			surface.SetDrawColor( 130, 0, 0, 255)
			surface.DrawRect( 0, 35, 250, 5 )
		cam.End3D2D()
	end
	
end