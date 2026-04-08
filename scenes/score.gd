extends Node2D

func _ready():
	Game.current_level_path = scene_file_path
	Game.reset_level_score()
	$CanvasLayer/Label.text = "%d" % Game.total_score
	$Music.finished.connect(_on_music_finished)
	$Music.play()

func _on_music_finished():
	$Music.play()
	
func _process(_delta):
	$CanvasLayer/Label.text = "%d" % Game.total_score
