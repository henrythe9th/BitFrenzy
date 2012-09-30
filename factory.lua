-- gameUI library
module(..., package.seeall)

local Ball = require("ball")

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

	if ( event.other.name == "ball" ) then
	
		if ( self ) then
			local x = self.x
			local y = self.y
			local spawn1 = function() return spawn_mini_tri( x, y ) end
			local spawn2 = function() return spawn_mini_tri( x+5, y) end
			local spawn3 = function() return spawn_mini_tri( x-5, y ) end
			local spawn4 = function() return spawn_mini_tri( x, y-5) end
			
			timer.performWithDelay(50, spawn1)
			timer.performWithDelay(50, spawn2)
			timer.performWithDelay(50, spawn3)
			timer.performWithDelay(50, spawn4)
				
			self:removeSelf()
			self = nil	
		end
	end
end

function hex_explode( self, event ) 

	if ( event.other.name == "ball" ) then
	
		if ( self ) then
			local x = self.x
			local y = self.y
			local spawn1 = function() return spawn_mini_hex( x, y ) end
			local spawn2 = function() return spawn_mini_hex( x+5, y) end
			local spawn3 = function() return spawn_mini_hex( x-5, y ) end
			local spawn4 = function() return spawn_mini_hex( x, y-5) end
			
			timer.performWithDelay(50, spawn1)
			timer.performWithDelay(50, spawn2)
			timer.performWithDelay(50, spawn3)
			timer.performWithDelay(50, spawn4)
				
			self:removeSelf()
			self = nil	
		end
	end

end

function spawn_big_enemy()
	
	type = math.random(1,2)
	if ( type == 1) then
		spawn_big_tri()
	elseif ( type == 2 ) then
		spawn_big_hex()
	end
	
end

function spawn_big_tri()
	big_tri = display.newImage( "resources/tri_large.png" )
	big_tri.name = "big_tri"
	big_tri.big = true
	
	x = math.random(50, display.contentWidth-50)
	y = math.random(20, 50)
	big_tri.x, big_tri.y = x, y
	
	physics.addBody( big_tri, { density = 5.0, friction=0.3, bounce = 0.1 } )
	
	big_tri.postCollision = tri_explode
	big_tri:addEventListener("postCollision", big_tri)

end

function spawn_mini_tri( x, y )

	tri = display.newImage( "resources/tri_small.png", 32, 32 )
	tri.x, tri.y = x, y
	tri.rotation = math.random(0, 355)
	tri.name = "small_tri"
	tri.big = false
	
	physics.addBody( tri, { density=1.0, friction=0.3, bounce=0.3 } )
	
	local x_i = math.random(-10, 10)
	local y_i = math.random(-10, 10)
	tri:applyLinearImpulse( x_i, y_i, tri.x, tri.y )
	
end

function spawn_big_hex()
	big_hex = display.newImage( "resources/hex_large.png" )
	big_hex.name = "big_hex"
	big_hex.big = true
	
	x = math.random(50, display.contentWidth-50)
	y = math.random(20, 50)
	big_hex.x, big_hex.y = x, y
	
	physics.addBody( big_hex, { density = 5.0, friction=0.3, bounce = 0.1 } )
	
	big_hex.postCollision = hex_explode
	big_hex:addEventListener("postCollision", big_hex)
end

function spawn_mini_hex( x, y )
	hex = display.newImage( "resources/hex_small.png", 32, 32 )
	hex.x, hex.y = x, y
	hex.rotation = math.random(0,355)
	hex.name = "small_hex"
	hex.big = false
	
	physics.addBody( hex, { density=1.0, friction=0.3, bounce=0.3 } )
	
	local x_i = math.random(-10, 10)
	local y_i = math.random(-10, 10)
	hex:applyLinearImpulse( x_i, y_i, hex.x, hex.y )
	
end


	

