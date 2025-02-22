extends CharacterBody2D
class_name Player

const SPEED = 120.0
const JUMP_VELOCITY = -200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

var is_splitting = false  # Prevent movement while splitting
var can_split = true  # Prevent infinite splitting

func _physics_process(delta: float) -> void:
	if is_splitting:
		return  # Stop movement when splitting
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func split():
	if not can_split:  # Prevent splitting again immediately
		return
	
	is_splitting = true
	can_split = false  # Disable splitting until recombined
	
	animated_sprite.play("split")
	await animated_sprite.animation_finished
	is_splitting = false
	can_split = true
