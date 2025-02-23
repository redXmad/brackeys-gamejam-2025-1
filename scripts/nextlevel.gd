extends Area2D

const FILE_PATH = "res://scenes/levels/level_"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # Replace with function body.
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		AudioController.play_end_level()
		await get_tree().create_timer(1).timeout
		
		var next_level_path = FILE_PATH + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
		
