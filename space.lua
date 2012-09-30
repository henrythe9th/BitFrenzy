-----------------------------------------------------------------------------------------
--
-- space.lua
--
-----------------------------------------------------------------------------------------

local factory = require("factory")
local storyboard = require( "storyboard" )
local Level = require("level")
local Ship = require("ship")
local movieclip = require("movieclip")
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight * 0.5
local minY = halfH + 100
-- Audio for slash sound (sound you hear when user swipes his/her finger across the screen)
local slashSounds = {slash1 = audio.loadSound("slash1.wav"), slash2 = audio.loadSound("slash2.wav"), slash3 = audio.loadSound("slash3.wav")}
local slashSoundEnabled = true -- sound should be enabled by default on startup
local minTimeBetweenSlashes = 150 -- Minimum amount of time in between each slash sound
local minDistanceForSlashSound = 50 -- Amount of pixels the users finger needs to travel in one frame in order to play a slash sound
local maxSlashBoundHeigh = 300 -- Max height of the area that a user can slash (measured from the top of the screen)
local maxPoints = 5
local lineThickness = 5
local lineFadeTime = 200
local endPoints = {}

local bullets = display.newGroup()

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	physics.setGravity(0,0.1);
	
	-- display a background image
	local background1 = display.newImage( "space.jpg" )
	background1.x, background1.y = 160, -720
	local background2 = display.newImage( "space.jpg" )
	background2.x, background2.y = 160, -240
	local background3 = display.newImage( "space.jpg" )
	background3.x, background3.y = 160, 240
	local background4 = display.newImage( "space.jpg" )
	background4.x, background4.y = 160, 710
	
	--background
	Level.decorate(group)
	group:setup_walls()
	
	factory.spawn_ball()
	timer.performWithDelay( 5000, factory.spawn_big_tri, 10 )

	--ship
	local player_ship = movieclip.newAnim({'shipA.png', 'shipB.png'})
	Ship.decorate(player_ship)
	player_ship:play()
	
	--the update function will control most everything that happens in our game
	--this will be called every frame(30 frames per second in our case, which is the Corona SDK default)
	local function update( event )
	
		--updateBackgrounds will call a function made specifically to handle the background movement
		updateBackgrounds()
	
	end
	
	function updateBackgrounds()
		--background movement
		background1.y = background1.y + (0.5)
		background2.y = background2.y + (0.5)
		background3.y = background3.y + (0.5)
		background4.y = background4.y + (0.5)

		--if the sprite has moved off the screen move it back to the
		--other side so it will move back on
		if(background1.y > 800) then
			background1.y = -700
		end

		if(background2.y > 800) then
			background2.y = -700
		end
		
		if(background3.y > 800) then
			background3.y = -700
		end

	end
	
	--this is how we call the update function, make sure that this line comes after the
	--actual function or it will not be able to find it
	--timer.performWithDelay(how often it will run in milliseconds, function to call,
	--how many times to call(-1 means forever))
	timer.performWithDelay(1, update, -1)
	

	-- all display objects must be inserted into group
	group:insert( background1 )
	group:insert( background2 )
	group:insert( background3 )
	group:insert( background4 )
end

--Slashing Events
function drawSlashLine(event)

	if (event.y >= maxSlashBoundHeigh) then return false end
	-- Play a slash sound
	if(endPoints ~= nil and endPoints[1] ~= nil) then
		local distance = math.sqrt(math.pow(event.x - endPoints[1].x, 2) + math.pow(event.y - endPoints[1].y, 2))
		if(distance > minDistanceForSlashSound and slashSoundEnabled == true) then 
			playRandomSlashSound();  
			slashSoundEnabled = false
			timer.performWithDelay(minTimeBetweenSlashes, function(event) slashSoundEnabled = true end)
		end
	end

	-- Insert a new point into the front of the array
	table.insert(endPoints, 1, {x = event.x, y = event.y, line= nil}) 

	-- Remove any excessed points
	if(#endPoints > maxPoints) then 
		table.remove(endPoints)
	end

	for i,v in ipairs(endPoints) do
		local line = display.newLine(v.x, v.y, event.x, event.y)
		line.width = lineThickness
		transition.to(line, {time = lineFadeTime, alpha = 0, width = 0, onComplete = function(event) line:removeSelf() end})		
	end

	if(event.phase == "ended") then		
		while(#endPoints > 0) do
			table.remove(endPoints)
		end
	end
end

-- Return a random value between 'min' and 'max'
function getRandomValue(min, max)
	return min + math.abs(((max - min) * math.random()))
end

function playRandomSlashSound()

	audio.play(slashSounds["slash" .. math.random(1, 3)])
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

Runtime:addEventListener("touch", drawSlashLine)
-----------------------------------------------------------------------------------------

return scene