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
	
	if params and params.group then
		--params.group:insert(obj)
	end
	
	local stage = display.getCurrentStage()
	
	function moveShip(event)
		local targetX = obj.x + 50 * event.xGravity
			if targetX >= obj.width and targetX <= screenW - obj.width then
				obj.x = targetX
				if obj.ball ~= nil and obj.ball.isDragged == false then
					obj.ball.x = targetX
				end
			end
		return true
	end
	
	function armBullet( event )
		
	print ( event.x )
	print ( event.y )
		
		if event.phase == "began" then
		
			weapon2_down.isVisible = true
			shoot = function () return shootBullet(event) end
			
			bullet_timer = timer.performWithDelay(333, shoot, -1)
			
		elseif event.phase == "ended" or event.phase == "cancelled" then
			
			weapon2_down.isVisible = false
			timer.cancel(bullet_timer)
		end
	end
	
	function stopBullets( event )
		if ( event.phase == "ended" ) then
			weapon2_down.isVisible = false
			timer.cancel(bullet_timer)
		end
	end
	
	--shoot bullet
	function shootBullet( event)
		if obj.ball == nil or obj.ball.isDragged == true then
			local ship_bullet = display.newImage('bullet.png')
			Bullet.decorate(ship_bullet, { x = obj.x, y = obj.y - obj.height + 10})
		end
	end
	
	--load Ball weapon
	function loadBall( event )
		
		if event.phase == "began" then
			weapon1_down.isVisible = true
		elseif event.phase == "ended" then
			weapon1_down.isVisible = false
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
		weapon1:removeEventListener("touch", loadBall)
		weapon2:removeEventListener("touch", armBullet)
		weapon1:removeSelf()
		weapon2:removeSelf()
		obj:removeSelf()
	end
	
	bullet_timer = 0
	
	weapon1 = display.newImage("resources/button1.png", display.contentWidth - 42, display.contentHeight - 84)
	weapon1_down = display.newImage("resources/button1_down.png", display.contentWidth - 42, display.contentHeight - 84)
	weapon1_down.isVisible = false
	
	weapon2 = display.newImage("resources/button2.png", display.contentWidth - 42, display.contentHeight - 42)
	weapon2_down = display.newImage("resources/button2_down.png", display.contentWidth - 42, display.contentHeight - 42)
	weapon2_down.isVisible = false
	
	
	weapon1:addEventListener("touch", loadBall)
	weapon2:addEventListener("touch", armBullet)
	
	system.setAccelerometerInterval( 70 )
	Runtime:addEventListener("accelerometer", moveShip)
	Runtime:addEventListener("touch", stopBullets)
	--obj:addEventListener("tap", shootBullet)
	--Runtime:addEventListener("tap", loadBall)


end