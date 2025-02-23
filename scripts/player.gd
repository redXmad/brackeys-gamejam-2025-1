extends CharacterBody2D
class_name Player

const SPEED: float = 85.0
const JUMP_VELOCITY: float = -210.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

@export var dead_body: PackedScene

var is_splitting = false  # Prevent movement while splitting
var can_split = true  # Prevent infinite splitting

enum States {
	IDLE,
	RUNNING,
	FIREBALL
}

var state: States

func _physics_process(delta: float) -> void:
	if is_splitting:
		return  # Stop movement when splitting
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		AudioController.play_jump()  # 🔹 Now the sound only plays on jump

	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true

	# Play animation
	if state != States.FIREBALL:
		if is_on_floor():
			if direction == 0:
				animation.play("idle")
			else:
				animation.play("run")
		else:
			animation.play("jump")  # This will only play the animation, no sound

	if state == States.FIREBALL:
		if velocity.y > 0:
			unfireball()

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func split(dead_body_position: float) -> void:
	if not can_split:  # Prevent splitting again immediately
		return
	
	is_splitting = true
	can_split = false  # Disable splitting until recombined
	
	animation.play("split")
	await animation.animation_finished
	is_splitting = false
	can_split = true
	var d = dead_body.instantiate()
	get_parent().add_child(d)
	d.position.y = dead_body_position
	d.position.x = global_position.x + 8

func fireball(fireball_speed: float) -> void:
	state = States.FIREBALL
	velocity.y = fireball_speed
	animation.play("fireball")

func unfireball() -> void:
	state = States.IDLE
