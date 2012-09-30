module(..., package.seeall)
local physics = require("physics")
local score = require("score")

function destroy ( event )
	
	local other = event.other
	
	if ( other and other.name ~= "bullet" and event.other.name ~= "ball" ) then
		if (other.name == "small_tri") then
			score.update( -1 )
		elseif (other.name == "big_tri") then
			score.update( -3 )
		end
		event.other:removeSelf()
		
		
	end

end

--decorator--------------------
function decorate(obj)	--object to decorate
	local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
	
	function obj:setup_walls()
		self.walls = {}
		
		--screen edges
		self.walls[1] = display.newRect(screenW, 0, 1, screenH)
		self.walls[2] = display.newRect(0, screenH, screenW, 1)
		self.walls[3] = display.newRect(0, -1, screenW, 1)
		self.walls[4] = display.newRect(-1, 0, 1, screenH)
		
		local staticMaterial = {density = 2, friction = 1, bounce=.4}
		for i=1, #self.walls do
			physics.addBody(self.walls[i], "static", staticMaterial)
			self:insert(self.walls[i])
		end
		
		score_wall = display.newRect( 0, screenH - 50, screenW, 0)
		physics.addBody( score_wall, "static", staticMaterial)
		score_wall.name = "score_wall"
		score_wall.isSensor = true
		score_wall:addEventListener("collision", destroy)
		
	end
	
end