extends Node2D

@onready var rotator = $Rotator

const SPIN_SPEED = 2.0

func _process(delta):
	rotator.rotation += SPIN_SPEED * delta
