extends Area2D

@export var target_portal : Node2D




func _on_body_entered(body: Node2D) -> void:
	if target_portal == null:
		return
	
	if "Player" in body.name:
		body.position = target_portal.position
