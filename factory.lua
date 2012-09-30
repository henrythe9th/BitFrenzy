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

function spawn_ball()
	
	ball_weapon = display.newImageRect( "resources/marble.png", 32, 32 )
	Ball.decorate(ball_weapon, { x = 150, y = 400})
	--ball.x, ball.y = 150, 400
	--physics.addBody( ball, { density=1.0, friction=0.3, bounce=0.3 } )

	--ball.name = "ball"
	--ball.dmg = 0
	
	--ball:addEventListener("touch", dragBody)
	
	--ball.collision = damage
	--ball:addEventListener( "collision", projectile ) 
end


function spawn_big_tri()
	
	tri = display.newImage( "resources/tri_large.png", 128, 128 )
	x = math.random(50, display.contentWidth-50)
	y = math.random(30, 60)
	tri.x, tri.y = x, y
	tri.name = "big_tri"
	
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
	

