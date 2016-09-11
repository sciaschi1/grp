include("shared.lua")

function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawEntityOutline( 1.0 ) -- Draw an outline of 1 world unit.
    self:DrawModel() -- Draws Model Client Side
 
   	//The amount to display
	local amount = 10

	local Pos = self:GetPos()
	local Ang1 = Angle( 0, 0, 90 )
	local Ang2 = Angle( 0, 0, 90 )

	Ang1:RotateAroundAxis( Ang1:Right(), self.rotate )
	Ang2:RotateAroundAxis( Ang2:Right(), self.rotate + 180 )

	//Draws front
	cam.Start3D2D( Pos + Ang1:Up() * 0, Ang1, 0.2 )
		draw.DrawText( "$ "..amount, "Default", 0, -50, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()

	//Draws back
	cam.Start3D2D( Pos + Ang2:Up() * 0, Ang2, 0.2 )
		draw.DrawText( "$ "..amount, "Default", 0, -50, Color( 0, 255, 0, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()

	//Resets the rotation
	if ( self.rotate > 359 ) then self.rotate = 0 end

	//Rotates
	self.rotate = self.rotate - ( 100*( self.lasttime-SysTime() ) )
	self.lasttime = SysTime()
end