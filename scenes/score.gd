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

	if has_node("Mobile/LeftButton"):
		$Mobile/LeftButton.button_down.connect(_on_left_pressed)
		$Mobile/LeftButton.button_up.connect(_on_left_released)

		$Mobile/RightButton.button_down.connect(_on_right_pressed)
		$Mobile/RightButton.button_up.connect(_on_right_released)

		$Mobile/JumpButton.pressed.connect(_on_jump_pressed)

func _on_music_finished():
	$Music.play()
	
func _process(_delta):
	$CanvasLayer/Label.text = "%d" % Game.total_score

func _on_left_pressed():
	player.set_move_left_pressed(true)

func _on_left_released():
	player.set_move_left_pressed(false)

func _on_right_pressed():
	player.set_move_right_pressed(true)

func _on_right_released():
	player.set_move_right_pressed(false)

func _on_jump_pressed():
	player.press_jump()

func _handle_mobile_controls():
	var is_mobile = OS.get_name() == "Android" or OS.get_name() == "iOS"
	
	if not is_mobile:
		if has_node("Mobile"):
			$Mobile.visible = false
		if has_node("RotateOverlay"):
			$RotateOverlay.visible = false
		return

	var size = get_viewport_rect().size
	var is_landscape = size.x > size.y

	if has_node("Mobile"):
		$Mobile.visible = is_landscape
	if has_node("RotateOverlay"):
		$RotateOverlay.visible = not is_landscape
	
func _notification(what):
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		_handle_mobile_controls()

func _on_restart_pressed():
	restart_button.disabled = true
	get_tree().reload_current_scene()
