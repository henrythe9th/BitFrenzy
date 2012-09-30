-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

local function onScreenTouch( event )
    -- go to space.lua scene
	storyboard.gotoScene( "space", "slideDown", 500 )
	
	return true	-- indicates successful touch	
end

-- begin listening for screen touches
Runtime:addEventListener( "touch", onScreenTouch )

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

	-- display a background image
	local background = display.newImage( "space.jpg" )
	background.x, background.y = 160, 240
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "bitfrenzylogo.png", 264, 120 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 150
	
	local startButton = display.newImage( "startbutton.png", 200, 100)
	startButton.x = display.contentWidth*0.5
	startButton.y = display.contentHeight - 125
	
	local function1, function2
	local trans

	function function1(e)
	  trans = transition.to(startButton,{time=1000,alpha=1, onComplete=function2})
	end

	function function2(e)
	  trans = transition.to(startButton,{time=1000,alpha=0, onComplete=function1})
	end

	transition.to(startButton,{time=1000,alpha=0, onComplete = function1})
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( titleLogo )
	group:insert( startButton )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	

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