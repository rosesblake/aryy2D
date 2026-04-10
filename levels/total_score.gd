extends CanvasLayer

func _ready():
	$CenterContainer/Label.text = str(Game.total_score) + "/68 Total Orbs Collected"
