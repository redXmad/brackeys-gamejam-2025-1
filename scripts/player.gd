extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

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

	# Create two split characters
	var left_clone = duplicate()
	var right_clone = duplicate()
	
	left_clone.position = position + Vector2(-20, 0)
	right_clone.position = position + Vector2(20, 0)

	get_parent().add_child(left_clone)
	get_parent().add_child(right_clone)

	queue_free()  # Remove the original player

	# Start recombination after delay
	await get_tree().create_timer(2.0).timeout
	recombine(left_clone, right_clone)

func recombine(left_clone, right_clone):
	# Merge the clones into one player
	var new_player = duplicate()
	new_player.position = (left_clone.position + right_clone.position) / 2  # Set new position
	new_player.can_split = false  # Prevent splitting again too fast

	get_parent().add_child(new_player)

	# Remove the clones
	left_clone.queue_free()
	right_clone.queue_free()

	# Move the player slightly forward so they don’t touch spikes again
	new_player.position.y -= 10

	# Reactivate split after a short delay
	await get_tree().create_timer(2.0).timeout
	new_player.can_split = true
