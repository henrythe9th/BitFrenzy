module(..., package.seeall)
local physics = require("physics")

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
	end
end