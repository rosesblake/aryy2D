extends Label

@export var base_font_size: int = 250
@export var min_font_size: int = 40

var pulse_tween: Tween

func _ready() -> void:
	resize_text()
	get_viewport().size_changed.connect(resize_text)
	start_pulse()

func resize_text() -> void:
	var screen_size = get_viewport_rect().size
	var scale_factor = min(screen_size.x / 1920.0, screen_size.y / 1080.0)
	var new_size = max(int(base_font_size * scale_factor), min_font_size)
	add_theme_font_size_override("font_size", new_size)

func start_pulse() -> void:
	if pulse_tween:
		pulse_tween.kill()

	pulse_tween = create_tween()
	pulse_tween.set_loops()

	pulse_tween.tween_method(_set_pulse_font_size, 1.0, 1.06, 1.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	pulse_tween.tween_method(_set_pulse_font_size, 1.06, 1.0, 1.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _set_pulse_font_size(multiplier: float) -> void:
	var screen_size = get_viewport_rect().size
	var scale_factor = min(screen_size.x / 1920.0, screen_size.y / 1080.0)
	var sized_base = max(int(base_font_size * scale_factor), min_font_size)
	add_theme_font_size_override("font_size", int(sized_base * multiplier))
