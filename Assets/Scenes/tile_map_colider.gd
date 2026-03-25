class_name Controler
extends TileMapLayer
@onready var _timer: Timer = $Time_until_detect
var current_hovered_tile: Vector2i = Vector2i(-1, -1)

signal tile_entered

func _ready():
	_timer.start()
		
func _process(delta: float) -> void:
	if _timer.is_stopped():
		_check_hover()
	pass


func _check_hover():
	var local_mouse = to_local(get_global_mouse_position())
	var coords = local_to_map(local_mouse)
	var new_hovered = coords if get_cell_source_id(coords) != -1 else Vector2i(-1, -1)
	
	if new_hovered != current_hovered_tile:
		if current_hovered_tile != Vector2i(-1, -1):
			_on_tile_hover_exited(current_hovered_tile)
		if new_hovered != Vector2i(-1, -1):
			_on_tile_hover_entered(new_hovered)
		current_hovered_tile = new_hovered

func _on_tile_hover_entered(tile_coords: Vector2i):
	emit_signal("tile_entered")
	print("Entered tile ", tile_coords)

func _on_tile_hover_exited(tile_coords: Vector2i):
	print("Exited tile ", tile_coords)
