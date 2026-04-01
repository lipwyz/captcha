extends Control
@onready var tile_map_layer: Controler = $TileMapLayer
@onready var panel: Panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for cata_vento in get_children():
		if cata_vento is Cata_vento: 
			cata_vento.colided.connect(entered)   # conecta o sinal do Area2D
	
	tile_map_layer.tile_entered.connect(entered)
<<<<<<< Updated upstream
	pass # Replace with function body.
=======
>>>>>>> Stashed changes

func entered():
	panel.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
