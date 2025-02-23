extends Area2D

@export var fireball_speed: float = -400.0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.fireball(fireball_speed)
