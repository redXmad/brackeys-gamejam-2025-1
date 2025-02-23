extends Area2D

@onready var dead_body_position: Marker2D = $DeadBodyPosition

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.split(dead_body_position.global_position.y)  # Call split function in Player script
