extends Node2D

@onready var start_button = $UI/CanvasLayer/CenterContainer/StartButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://levels/Level2.tscn")
