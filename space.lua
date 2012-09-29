-----------------------------------------------------------------------------------------
--
-- space.lua
--
-----------------------------------------------------------------------------------------

local factory = require("factory")
local storyboard = require( "storyboard" )
local level = require("level")
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight * 0.5
local minY = halfH + 100

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

	factory.set_group( group )
	
	physics.setGravity(0,0.1);
	
	-- display a background image
	local background1 = display.newImage( "space.jpg" )
	background1.x, background1.y = 160, -760
	local background2 = display.newImage( "space.jpg" )
	background2.x, background2.y = 160, -240
	local background3 = display.newImage( "space.jpg" )
	background3.x, background3.y = 160, 240
	
	level.decorate(group)
	group:setup_walls()
	
	factory.spawn_big_tri( 130, 150 )

	local block = display.newImageRect( "resources/pink_block.png", 32, 32 )
	block.x, block.y = 150, 400
	
	local function dragBody( event )
		touch.dragBody( event, { minY = minY} )
	end
	
	
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
	
	
	physics.addBody( block, { density=1.0, friction=0.3, bounce=0.3 } )
	
	
	-- all display objects must be inserted into group
	group:insert( background1 )
	group:insert( background2 )
	group:insert( background3 )
	
	group:insert( block )
	
	block:applyTorque( 10 )
	
	block:addEventListener("touch", dragBody)

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

-----------------------------------------------------------------------------------------

return scene