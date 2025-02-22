extends Area2D

@export var source_portal: Portal
@export var destination_portal: Portal

@export var player: Player  # Make sure this is the correct path to your player

var slow_time_active = false
var slow_time_duration = 0.1  # How long time will stay slow (in seconds)

func _get_configuration_warninga() -> PackedStringArray:
	if !source_portal:
		return ["Need a source portal"]
	return []

func _ready() -> void:
	print(!source_portal)
	if source_portal and destination_portal:
		destination_portal.scale.y *= -1
		source_portal.target_portal = destination_portal
		disable_portals()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not slow_time_active:
		source_portal.global_position = body.position + Vector2(0, 5)
		destination_portal.global_position = Vector2(body.position.x, 10)
		enable_portals()
		start_slow_time()

# Function to slow time when the player enters the area
func start_slow_time():
	slow_time_active = true
	Engine.time_scale = 0.1  # Slow down time by 90%
	
	# Wait for the timer to timeout
	await get_tree().create_timer(slow_time_duration).timeout
	
	stop_slow_time()
	disable_portals()

# Function to stop the slow time effect
func stop_slow_time():
	slow_time_active = false
	Engine.time_scale = 1.0  # Restore normal speed

func disable_portals():
	source_portal.disable_portal()
	destination_portal.disable_portal()

func enable_portals():
	source_portal.enable_portal()
	destination_portal.enable_portal()
