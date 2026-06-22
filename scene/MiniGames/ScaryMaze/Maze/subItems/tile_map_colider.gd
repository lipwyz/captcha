class_name ControladorTileMap
extends TileMapLayer

var current_hovered_tile: Vector2i = Vector2i(-1, -1)

signal tile_entered

var iniciado: bool = false

func set_iniciado(_iniciado: bool) -> void:
	iniciado = _iniciado

func _physics_process(_delta: float) -> void:
	if iniciado:
		_check_hover()

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

func _on_tile_hover_entered(_tile_coords: Vector2i):
	tile_entered.emit()
	#print("Entered tile ", tile_coords)

func _on_tile_hover_exited(_tile_coords: Vector2i):
	#print("Exited tile ", tile_coords)
	pass
