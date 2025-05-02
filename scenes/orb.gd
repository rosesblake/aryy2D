extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().current_scene.add_point()
		queue_free()  # deletes the skull orb
