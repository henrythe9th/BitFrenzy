module(..., package.seeall)
local physics = require("physics")
local Bullet = require("bullet")
local Ball = require("ball")

--decorator--------------------
function decorate(obj, params)	--object to decorate
	local screenW = display.contentWidth
	local screenH = display.contentHeight
	obj.x = screenW * 0.5
	obj.y = screenH - obj.height
	obj.name = 'ship'
	obj.ball = nil
	obj:play()
	
	--if params and params.group then
	--	params.group:insert(obj)
	--end
	
	--move ship event handler
	local stage = display.getCurrentStage()
	
	function moveShip(event)
		local targetX = obj.x + 100 * event.xGravity
			if targetX >= obj.width and targetX <= screenW - obj.width then
				obj.x = targetX
				if obj.ball ~= nil and obj.ball.isDragged == false then
					obj.ball.x = targetX
				end
			end
		return true
	end
	
	--shoot bullet
	function shootBullet(event)
		local ship_bullet = display.newImage('bullet.png')
		Bullet.decorate(ship_bullet, { x = obj.x, y = obj.y - obj.height + 10})
	end
	
	--load Ball weapon
	function loadBall(event)
		if event.numTaps == 2 then
			--the tap must not occure on the ship and must occur near the bottom of the screen
			if (event.x < obj.x or event.x > obj.x+obj.width)
				and (event.y < obj.y or event.y > obj.y + obj.height) and event.y >= obj.y - 50 then
				if obj.ball == nil or obj.ball.dmg > 0 then
					obj.ball = display.newImageRect( "resources/marble.png", 32, 32 )
					Ball.decorate(obj.ball, { x = obj.x, y = obj.y - obj.height + 10})
				end
			end
		end
	end
	
--destroy--------------------
	function obj:remove()
		Runtime:removeEventListener("accelerometer", moveShip)
		obj:removeEventListener("tap", shootBullet)
		Runtime:removeEventListener("tap", loadBall)
		obj:removeSelf()
	end
	
	system.setAccelerometerInterval( 100 )
	Runtime:addEventListener("accelerometer", moveShip)
	obj:addEventListener("tap", shootBullet)
	--obj:addEventListener("accelerometer", loadBall)
	
	Runtime:addEventListener("tap", loadBall)

end