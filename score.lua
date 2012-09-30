module(..., package.seeall)

score = 30
score_text = display.newText( score, 10, 0, native.systemFont, 24 )

function update( val )
	score = score + val
	score_text.text = score
end

function isGameOver()
	return score <= 0
end