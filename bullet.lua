module(..., package.seeall)
local physics = require("physics")

local shot = audio.loadSound('shot.mp3')
local score = require("score")


--decorator--------------------
function decorate(obj, params)	--object to decorate
	local timerSource = {}
	obj.x = params.x
	obj.y = params.y
	obj.name = 'bullet'
	
	audio.play(shot)
	
	physics.addBody(obj)
	
	--move bullet upwards
	function moveBullet()
		if obj.y then
			obj.y = obj.y - 10
			if obj.y < -obj.height then
				obj.remove()
			end
		end
	end
	
	--collison for bullet
	function bulletCollision(event)
		local other = event.other
		
		if other.name and other.big == false then
			other:removeSelf()
			score.update(1)
		end
		
		if other.name ~= "score_wall" then
			obj.remove()
		end
		
	end
--destroy--------------------
	function obj:remove()
		obj:removeEventListener("collision", bulletCollision)
		timer.cancel(timerSource)
		obj:removeSelf()
		
	end
	
	
	timerSource = timer.performWithDelay(10, moveBullet, -1)
	obj:addEventListener('collision', bulletCollision)
end