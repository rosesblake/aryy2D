extends Node2D

@onready var player = $Player
@onready var restart_button = $RestartCanvas/CenterContainer/RestartButton

func _ready():
	Game.current_level_path = scene_file_path
	Game.reset_level_score()
	$CanvasLayer/Label.text = "%d" % Game.total_score
	$Music.finished.connect(_on_music_finished)
	$Music.play()

	restart_button.pressed.connect(_on_restart_pressed)

	_handle_mobile_controls()

func _on_music_finished():
	$Music.play()

func _process(_delta):
	$CanvasLayer/Label.text = "%d" % Game.total_score

func _handle_mobile_controls():
	var is_mobile = DisplayServer.is_touchscreen_available()

	if not is_mobile:
		if has_node("Mobile"):
			$Mobile.visible = false
		if has_node("RotateOverlay"):
			$RotateOverlay.visible = false
		return

	if has_node("Mobile"):
		$Mobile.visible = true
	if has_node("RotateOverlay"):
		$RotateOverlay.visible = false

func _notification(what):
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		_handle_mobile_controls()

func _on_restart_pressed():
	restart_button.disabled = true
	get_tree().reload_current_scene()
