module(..., package.seeall)
local physics = require("physics")
local Bullet = require("bullet")
local Ball = require("ball")


--decorator--------------------
function decorate(obj)	--object to decorate
	local screenW = display.contentWidth
	local screenH = display.contentHeight
	obj.x = screenW * 0.5
	obj.y = screenH - obj.height
	obj.name = 'ship'
	obj.ball = nil
	
	--move ship event handler
	local stage = display.getCurrentStage()
	
	function moveShip(event)
		local target = event.target
		if event.phase == "began" then
			--event.target.alpha = 0.5
			stage:setFocus(target, event.id)
			target.isFocus = true
		elseif(event.phase == 'moved') then
			if event.x >= obj.width and event.x <= screenW - obj.width then
				obj.x = event.x
			end
		elseif event.phase == "ended" or event.phase == "cancelled" then
			stage:setFocus(nil)
			target.isFocus = false
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
		obj.removeEventListener("touch", moveShip)
		obj.removeEventListener("tap", shootBullet)
		Runtime.removeEventListener("tap", loadBall)
		obj:removeSelf()
	end
	
	obj:addEventListener("touch", moveShip)
	obj:addEventListener("tap", shootBullet)
	--obj:addEventListener("accelerometer", loadBall)
	
	Runtime:addEventListener("tap", loadBall)
end