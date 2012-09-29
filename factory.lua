-- gameUI library
module(..., package.seeall)

local physics = require "physics"

function damage( self, event )

	print ( self.dmg )

	if ( event.phase == "ended" ) then
	
		self.dmg = self.dmg + 1
		if ( self.dmg > 4 ) then
			self:removeSelf()
		end
	end
	
end

function tri_explode( self, event )

	if ( event.other.name == "big_p" ) then
	
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
end

function dragBody( event )
	touch.dragBody( event, { minY = display.contentHeight / 2 + 100 } )
end


function spawn_big_projectile()
	
	projectile = display.newImageRect( "resources/pink_block.png", 32, 32 )
	projectile.x, projectile.y = 150, 400
	physics.addBody( projectile, { density=1.0, friction=0.3, bounce=0.3 } )

	projectile.name = "big_p"
	projectile.dmg = 0
	
	projectile:addEventListener("touch", dragBody)
	
	projectile.collision = damage
	projectile:addEventListener( "collision", projectile ) 
end


function spawn_big_tri( x, y)
	
	tri = display.newImage( "resources/tri_large.png", 128, 128 )
	tri.x, tri.y = x, y
	
	physics.addBody( tri, { density=5.0, friction=0.5, bounce=0.1 } )
	
	tri.postCollision = tri_explode
	tri:addEventListener("postCollision", tri)
	
end

function spawn_mini_tri( r, x, y )

	tri = display.newImage( "resources/tri_small.png", 32, 32 )
	tri.x, tri.y = x, y
	tri.rotation = r
	tri.name = "small_tri"
	
	physics.addBody( tri, { density=1.0, friction=0.3, bounce=0.3 } )
	
	local x_i = math.random(-10, 10)
	local y_i = math.random(-10, 10)
	tri:applyLinearImpulse( x_i, y_i, tri.x, tri.y )
	
end
	

