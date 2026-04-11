extends CharacterBody2D

const DeathLabelScene = preload("res://scenes/DeathLabel.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const GRAVITY = 1200.0

@onready var sprite = $AnimatedSprite2D

var is_dead = false
var jump_count = 0
var max_jumps = 2
var spawn_position: Vector2
var death_label_instance = null

var move_left_pressed = false
var move_right_pressed = false
var jump_pressed = false

func _ready():
	spawn_position = global_position

func kill():
	if is_dead:
		return

	is_dead = true
	sprite.stop()
	velocity = Vector2(100, -300)

	death_label_instance = DeathLabelScene.instantiate()
	get_tree().current_scene.add_child(death_label_instance)

	get_tree().create_timer(1.0).timeout.connect(_on_death_timeout)

func _on_death_timeout():
	respawn()

func respawn():
	global_position = spawn_position
	velocity = Vector2.ZERO
	is_dead = false
	jump_count = 0
	sprite.play("idle")

	if death_label_instance:
		death_label_instance.queue_free()
		death_label_instance = null

func set_move_left_pressed(value: bool):
	move_left_pressed = value

func set_move_right_pressed(value: bool):
	move_right_pressed = value

func press_jump():
	jump_pressed = true

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity.y += GRAVITY * delta
		move_and_slide()
		return

	var was_on_floor = is_on_floor()

	if not was_on_floor:
		velocity.y += GRAVITY * delta
	else:
		jump_count = 0

	if (Input.is_action_just_pressed("ui_accept") or jump_pressed) and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	jump_pressed = false

	var direction = 0.0

	if Input.is_action_pressed("ui_left") or move_left_pressed:
		direction -= 1.0
	if Input.is_action_pressed("ui_right") or move_right_pressed:
		direction += 1.0

	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if not is_on_floor() or is_dead:
		sprite.stop()
	elif direction != 0:
		if sprite.animation != "run" or !sprite.is_playing():
			sprite.play("run")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
