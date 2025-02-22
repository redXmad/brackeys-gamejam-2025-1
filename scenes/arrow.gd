extends Node2D

const ARROW_SPEED: float = 400.0
var direction: Vector2
var shooting: bool = true

func _process(delta: float) -> void:
	if shooting:
		scale.x = -1 if direction.x < 0 else 1
		global_position += direction * ARROW_SPEED * delta

func _on_arrow_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		shooting = false
