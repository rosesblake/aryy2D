extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		Game.add_point()
		queue_free()
