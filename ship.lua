module(..., package.seeall)
local physics = require("physics")
local Bullet = require("bullet")


--decorator--------------------
function decorate(obj)	--object to decorate
	local screenW = display.contentWidth
	local screenH = display.contentHeight
	obj.x = screenW * 0.5
	obj.y = screenH - obj.height
	obj.name = 'ship'
	
	--physics.addBody(obj)
	
	
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
	
	function shootBullet(event)
		local ship_bullet = display.newImage('bullet.png')
		Bullet.decorate(ship_bullet, { x = obj.x, y = obj.y - obj.height + 10})
	end
	
--destroy--------------------
	function obj:remove()
		obj.removeEventListener("touch", moveShip)
		obj:removeSelf()
	end
	
	obj:addEventListener("touch", moveShip)
	obj:addEventListener("tap", shootBullet)
end