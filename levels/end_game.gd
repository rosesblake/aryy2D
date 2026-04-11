extends CanvasLayer

@onready var continue_button = $CenterContainer/ContinueButton

func _ready():
	continue_button.pressed.connect(_on_continue_pressed)

func _on_continue_pressed():
	go_to_site()

func go_to_site():
	continue_button.disabled = true
	OS.shell_open("https://aryyzona.com/home")
