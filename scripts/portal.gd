extends Area2D
class_name Portal

@export var target_portal : Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(delta: float) -> void:
	print(animation_player.current_animation)

func _on_body_entered(body: Node2D) -> void:
	if target_portal == null:
		return
	
	if "Player" in body.name:
		body.position = target_portal.global_position

func enable_portal() -> void:
	process_mode = 0
	show()
	animation_player.play("spawn")

func disable_portal() -> void:
	animation_player.play("despawn")
	#process_mode = 4
	#hide()
