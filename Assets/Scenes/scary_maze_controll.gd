extends Control
@onready var tile_map_layer: Controler = $TileMapLayer
@onready var panel: Panel = $Panel
@onready var cata_vento: Area2D = $Cata_Vento
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map_layer.tile_entered.connect(entered)
	cata_vento.colided.connect(entered)
	pass # Replace with function body.

func entered():
	panel.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
