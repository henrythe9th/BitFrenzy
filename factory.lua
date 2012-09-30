-- gameUI library
module(..., package.seeall)

local Ball = require("ball")
local physics = require "physics"

local error_sound = audio.loadSound("error.wav")
local score = require("score")


function setGroup( g )

	group = g

end

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

function square_explode( self, event ) 

	if ( event.other.name == "ball" ) then
	
		if ( self ) then
			local x = self.x
			local y = self.y
			local spawn1 = function() return spawn_mini_square( x, y ) end
			local spawn2 = function() return spawn_mini_square( x+5, y) end
			local spawn3 = function() return spawn_mini_square( x-5, y ) end
			local spawn4 = function() return spawn_mini_square( x, y-5) end
			
			timer.performWithDelay(50, spawn1)
			timer.performWithDelay(50, spawn2)
			timer.performWithDelay(50, spawn3)
			timer.performWithDelay(50, spawn4)
				
			self:removeSelf()
			self = nil	
		end
	end

end

function rect_split( self, event ) 
	if ( event.phase == "moved"  ) then
		local deltaX = math.abs(event.x - event.xStart)
		local deltaY = math.abs(event.y - event.yStart)
		
		if (deltaX >= 20 or deltaY >= 20) then
			
			if ( self ) then
				local x = self.x
				local y = self.y
				
				spawn1 = function() return spawn_mini_rect( x-5, y ) end
				spawn2 = function() return spawn_mini_rect( x+5, y ) end
				
				timer.performWithDelay(50, spawn1)
				timer.performWithDelay(50, spawn2)
				
				self:removeSelf()
				self = nil
				
			end
		end
	end

end

function error_touch( self, event )
	if self.isSliced == nil or self.isSliced == false then
	--if event.phase == "ended" or event.phase == "cancelled" then
		audio.play(error_sound)
		score.update(-1)
		self.isSliced = true
	end
end


function spawn_big_enemy()
	
	type = math.random(1,3)
	if ( type == 1) then
		spawn_big_tri()
	elseif ( type == 2 ) then
		spawn_big_square()
	elseif ( type == 3 ) then
		spawn_big_rect()
	end
	
end

function spawn_big_rect()

	math.randomseed( os.time() )

	x = math.random(50, display.contentWidth-50)
	y = math.random(20, 50)
    
	big_rect = display.newRect(x, y, 70, 32)
	big_rect:setFillColor( 255, 255, 0 )
	
	big_rect.name = "big_rect"
	big_rect.big = true
	
	big_rect.rotation = math.random(0, 355)
	
	physics.addBody( big_rect, { density = 5.0, friction = 0.2, bounce = 0.1 } )
	
	big_rect.touch = rect_split
	big_rect:addEventListener("touch", big_rect)

	group:insert( big_rect )


end

function spawn_mini_rect( x, y )
	math.randomseed( os.time() )

	rect = display.newRect( x, y, 35, 20 )
	rect:setFillColor( 255, 255, 0 )
	rect.rotation = math.random(0, 355)
	rect.name = "small_rect"
	rect.big = false
	
	physics.addBody( rect , { density=1.0, friction=0.3, bounce=0.2 } )
	
	local x_i = math.random(-10, 10)
	local y_i = math.random(-10, 5)
	
	rect:applyLinearImpulse( x_i, y_i, rect.x, rect.y )
	
	group:insert( rect )

end

function spawn_big_tri()

	math.randomseed( os.time() )

	big_tri = display.newImage( "resources/tri_large.png" )
	big_tri.name = "big_tri"
	big_tri.big = true
	
	x = math.random(50, display.contentWidth-50)
	y = math.random(20, 50)
	big_tri.rotation = math.random(0, 355)
	
	physics.addBody( big_tri, { density = 5.0, friction=0.3, bounce = 0.1 } )
	
	big_tri.postCollision = tri_explode
	big_tri:addEventListener("postCollision", big_tri)
	big_tri.touch = error_touch
	big_tri:addEventListener("touch", big_tri)
	group:insert( big_tri )

end

function spawn_mini_tri( x, y )

	math.randomseed( os.time() )

	tri = display.newImage( "resources/tri_small.png")
	tri.x, tri.y = x, y
	tri.rotation = math.random(0, 355)
	tri.name = "small_tri"
	tri.big = false
	
	physics.addBody( tri, { density=1.0, friction=0.3, bounce=0.3 } )
	
	local x_i = math.random(-10, 10)
	local y_i = math.random(-10, 10)
	tri:applyLinearImpulse( x_i, y_i, tri.x, tri.y )
	
	group:insert( tri )
	
end

function spawn_big_square()

	math.randomseed( os.time() )

	x = math.random(50, display.contentWidth-50)
	y = math.random(20, 50)
	
	big_square = display.newRect( x, y, 50, 50 )
	big_square:setFillColor(0, 255, 0)
	big_square.name = "big_square"
	big_square.big = true
	
	big_square.rotation = math.random(0, 355)
	
	physics.addBody( big_square, { density = 5.0, friction=0.3, bounce = 0.1 } )
	
	big_square.postCollision = square_explode
	big_square:addEventListener("postCollision", big_square)
	big_square.touch = error_touch
	big_square:addEventListener("touch", big_square)

	group:insert( big_square )

end

function spawn_mini_square( x, y )

	math.randomseed( os.time() )

	square = display.newImage( "resources/square_small.png" )
	square.x, square.y = x, y
	square.rotation = math.random(0,355)
	square.name = "small_square"
	square.big = false
	
	physics.addBody( square, { density=1.0, friction=0.3, bounce=0.3 } )
	
	local x_i = math.random(-10, 10)
	local y_i = math.random(-10, 10)
	square:applyLinearImpulse( x_i, y_i, square.x, square.y )
	
	group_insert( square )
	
end


	

