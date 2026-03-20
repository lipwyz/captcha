extends Node2D
const ICON = preload("uid://dn6fmp6f8401k")
const CIRCLE_FALLING = preload("uid://c3qg8jnjpv6yh")

var time_since_last_spawn = 0.0
var spawn_interval = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_interval:
		time_since_last_spawn = 0.0
		spawn_circle()

func spawn_circle() -> void:
	var circle = CIRCLE_FALLING.instantiate()
	
	# Set random position
	circle.position = get_random_screen_position()
	
	add_child(circle)

func get_random_screen_position() -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size
	var x = randf_range(0, screen_size.x)
	var y = randf_range(0, screen_size.y)
	return Vector2(x, y)
