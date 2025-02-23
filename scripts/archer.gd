extends Area2D

@export var arrow: PackedScene

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer

var player: Player
var collider: Node2D

var player_inside_zone: bool = false

var arrow_direction: Vector2
var shooting: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_inside_zone:
		ray_cast_2d.target_position = (player.global_position + Vector2(0, -8)) - ray_cast_2d.global_position
		collider = ray_cast_2d.get_collider()
		if collider == player: #Player is detected
			arrow_direction = (player.global_position - global_position).normalized()
			animation.flip_h = arrow_direction.x < 0
			#print("Player Detected!")
			if not shooting:
				shoot()
				shoot_timer.start()
				shooting = true

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		ray_cast_2d.target_position = body.global_position
		player_inside_zone = true

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		#shoot_timer.stop()
		player_inside_zone = false
		shooting = false

func shoot() -> void:
	var a = arrow.instantiate()
	owner.add_child(a)
	a.show()
	animation.play("shoot")
	await animation.animation_finished
	a.direction = (player.global_position - global_position).normalized()
	a.global_position = global_position + Vector2(0, -8)

func _on_shoot_timer_timeout() -> void:
	if collider == player:
		shoot()
