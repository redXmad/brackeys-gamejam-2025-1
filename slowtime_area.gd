extends Area2D

@onready var player = get_node("/root/MainScene/Player")  # Make sure this is the correct path to your player

var slow_time_active = false
var slow_time_duration = 0.2  # How long time will stay slow (in seconds)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not slow_time_active:
		start_slow_time()

# Function to slow time when the player enters the area
func start_slow_time():
	slow_time_active = true
	Engine.time_scale = 0.1  # Slow down time by 90%
	
	# Wait for the timer to timeout
	await get_tree().create_timer(slow_time_duration).timeout
	
	stop_slow_time()


# Function to stop the slow time effect
func stop_slow_time():
	slow_time_active = false
	Engine.time_scale = 1.0  # Restore normal speed 
