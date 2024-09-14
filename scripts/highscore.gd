extends Label

var score: int = 0;

func _ready() -> void:
	self.text = str(score)

func increase() -> int:
	score += 1
	self.text = str(score)
	
	return score
	
