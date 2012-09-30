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
	
	--physics.addBody( obj, { density=1.0, friction=0.3, bounce=0.3 } )
	
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
		physics.addBody( obj, { density=1.0, friction=0.3, bounce=0.3 } )
		touch.dragBody( event, { minY = display.contentHeight / 2 + 50, maxDeltaX = 25} )
	end
	
	--collison for ball
	function ballCollision(event)
		local other = event.other

		if ( other.name == "score_wall" ) then 
			obj.remove()
		end
		
		if ( event.phase == "ended" ) then
		
			obj.dmg = obj.dmg + 1
			if ( obj.dmg > 4 ) then
				obj.remove()
			end
		end
		
	end
--destroy--------------------
	function removeBall()
		if obj.isDragged then
			obj.remove()
		end
	end
	
	function obj:remove()
		obj:removeEventListener("collision", ballCollision)
		timer.cancel(timerSource)
		obj:removeSelf()
		obj = nil
		
	end
	
	--remove ball after 5 sec if not already removed
	timerSource = timer.performWithDelay(5000, removeBall, -1)
	obj:addEventListener("touch", dragBall)
	obj:addEventListener('collision', ballCollision)
end