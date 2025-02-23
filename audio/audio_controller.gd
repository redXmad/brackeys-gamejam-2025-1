extends Node2D

@export var mute: bool = false

func _ready():
	if not mute:
		play_music()
		
func play_music():
	if not mute:
		$Music.play()
		
func play_jump() -> void:
	if not mute:
		$Jump.play()
		
func play_end_level() -> void:
	if not mute:
		$EndLevel.play()
