module(..., package.seeall)

score = 1000
score_text = display.newText( score, 10, 0, native.systemFont, 24 )

function update( val )
	score = score + val
	score_text.text = score
end