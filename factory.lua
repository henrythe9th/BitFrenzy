-- gameUI library
module(..., package.seeall)

local physics = require "physics"

function set_group( physics_group )
	
	group = physics_group

end

function tri_explode( self, event )
	if ( self ) then
		local x = self.x
		local y = self.y
		local spawn1 = function() return spawn_mini_tri( 180, x, y ) end
		local spawn2 = function() return spawn_mini_tri( 0, x+5, y) end
		local spawn3 = function() return spawn_mini_tri( 0, x-5, y ) end
		local spawn4 = function() return spawn_mini_tri( 0, x, y-5) end
		
		timer.performWithDelay(50, spawn1)
		timer.performWithDelay(50, spawn2)
		timer.performWithDelay(50, spawn3)
		timer.performWithDelay(50, spawn4)
		
			
		self:removeSelf()
		self = nil	
	end
end

function spawn_big_tri()
	
	tri = display.newImage( "resources/tri_large.png", 128, 128 )
	tri.x, tri.y = 150, 20
	
	physics.addBody( tri, { density=5.0, friction=0.5, bounce=0.1 } )
	
	tri.postCollision = tri_explode
	tri:addEventListener("postCollision", tri)
	
end

function spawn_mini_tri( r, x, y )

	tri = display.newImage( "resources/tri_small.png", 32, 32 )
	tri.x, tri.y = x, y
	tri.rotation = r
	
	physics.addBody( tri, { density=2.0, friction=0.3, bounce=0.1 } )
	local x_i = math.random(-10, 10)
	local y_i = math.random(-10, 10)
	tri:applyLinearImpulse( x_i, y_i, tri.x, tri.y )
	
end
	

