extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.split()  # Call split function in Player script
