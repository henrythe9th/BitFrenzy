module(..., package.seeall)
local physics = require("physics")

local shot = audio.loadSound("slash3.wav")


--decorator--------------------
function decorate(obj, params)	--object to decorate
	local timerSource = {}
	obj.x = params.x
	obj.y = params.y
	obj.name = 'ball'
	obj.dmg = 0
	obj.isDragged = false
	
	audio.play(shot)
	
	physics.addBody( obj, { density=1.0, friction=0.3, bounce=0.3 } )
	
	--moving of the ball along with the ship
	function moveBall(event)
		if(event.phase == 'moved') then
			if event.x >= obj.width and event.x <= screenW - obj.width then
				obj.x = event.x
			end
		end
		return true
	end
	
	--dragging of ball
	function dragBall( event )
		touch.dragBody( event, { minY = display.contentHeight / 2 + 50, maxDeltaX = 25} )
	end
	
	--collison for ball
	function ballCollision(event)
		local other = event.other

		if ( event.phase == "ended" ) then
		
			obj.dmg = obj.dmg + 1
			if ( obj.dmg > 4 ) then
				obj.remove()
			end
		end
		
	end
--destroy--------------------
	function obj:remove()
		obj:removeEventListener("collision", ballCollision)
		--timer.cancel(timerSource)
		obj:removeSelf()
		
	end
	
	
	--timerSource = timer.performWithDelay(10, moveBullet, -1)
	obj:addEventListener("touch", dragBall)
	obj:addEventListener('collision', ballCollision)
end