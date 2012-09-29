-- gameUI library
module(..., package.seeall)

local physics = require "physics"


function tri_explode( self, event )
	if ( event.phase == "ended" ) then
		if ( self ) then
			self:removeSelf()
			spawn_mini_tri(event.x, event.y)		
		end
	end
end

function spawn_big_tri()
	
	tri = display.newImage( "resources/tri_large.png", 128, 128 )
	tri.x, tri.y = 150, 20
	
	physics.addBody( tri, { density=5.0, friction=0.5, bounce=0.1 } )
	
	tri.collision = tri_explode
	tri:addEventListener("collision", tri)
	
end

function spawn_mini_tri( x, y )

	tri = display.newImage( "resources/tri_small.png", 32, 32 )
	tri.x, tri.y = x, y
	
end
	

