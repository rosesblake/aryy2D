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

	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
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
