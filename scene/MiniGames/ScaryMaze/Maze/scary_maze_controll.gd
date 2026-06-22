extends Control
@onready var tile_map_layer: Controler = $TileMapLayer
@onready var panel: Panel = $Panel
@onready var cata_vento: Area2D = $Cata_Vento
@onready var mouse_detector: Area2D = $mouseDetector
@onready var collision: CollisionShape2D = $mouseDetector/Collision

func _ready() -> void:
	collision.set_deferred("disabled", false)
	tile_map_layer.tile_entered.connect(entered)
	mouse_detector.collided.connect(entered)
	pass # Replace with function body.

func entered():
	if mouse_detector.collided.is_connected(entered):
		mouse_detector.collided.disconnect(entered)
	collision.set_deferred("disabled", true)
	panel.visible = true

func _process(delta: float) -> void:
	pass
