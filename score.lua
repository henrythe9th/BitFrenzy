module(..., package.seeall)

score = 0
score_text = display.newText( "Current Score: "..score, 0, 0, native.systemFont, 18 )

function update( val )
	score = score + val
	score_text.text = "Current Score: "..score
end

function isGameOver()
	return score <= 0
end