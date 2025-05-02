extends CharacterBody2D

const DeathLabelScene = preload("res://scenes/DeathLabel.tscn")  # <- update if your path is different

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 1200.0

var is_dead = false

func kill():
	if is_dead:
		return

	is_dead = true
	velocity = Vector2(100, -300)  # small jump to the right and upward

	var label_instance = DeathLabelScene.instantiate()
	get_tree().current_scene.add_child(label_instance)

	get_tree().create_timer(2.0).timeout.connect(_on_death_timeout)


func _on_death_timeout():
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	if is_dead:
		# let the death animation play with gravity
		velocity.y += GRAVITY * delta
		move_and_slide()
		return

	var v = velocity

	if not is_on_floor():
		v.y += GRAVITY * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		v.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		v.x = direction * SPEED
	else:
		v.x = move_toward(v.x, 0, SPEED)

	velocity = v
	move_and_slide()
