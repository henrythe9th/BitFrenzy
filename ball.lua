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
	
	audio.play(shot)
	
	physics.addBody( obj, { density=1.0, friction=0.3, bounce=0.3 } )
	
	
	--dragging of ball
	function dragBall( event )
		touch.dragBody( event, { minY = display.contentHeight / 2 + 100 } )
	end
	
	--collison for ball
	function ballCollision(event)
		local other = event.other

		if ( other.name == "score_wall" ) then 
			return
		end
		
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