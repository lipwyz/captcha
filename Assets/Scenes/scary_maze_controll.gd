extends Node

@onready var tile_map_layer: Tile_map_colider = $TileMapLayer
@onready var panel: Panel = $Panel
@onready var cata_vento: Area2D = $Cata_Vento   # agora aponta para o filho correto

func _ready() -> void:
	tile_map_layer.tile_entered.connect(entered)
	cata_vento.colided.connect(entered)   # conecta o sinal do Area2D

func entered():
	panel.visible = true
