class_name ScaryMaze
extends Control

signal falhou
signal ganhou

@onready var tile_map_layer: Controler = $TileMapLayer
@onready var mouse_detector: Area2D = $mouseDetector
@onready var collision: CollisionShape2D = $mouseDetector/Collision
@onready var panel_errar: Panel = $PanelErrar
@onready var area_2d_vitoria: Area2D = $Area2DVitoria

func _ready() -> void:
	# espera um pouco antes de ligar a colisao
	await get_tree().create_timer(0.2).timeout
	collision.set_deferred("disabled", false)
	# conecta os sianis de mouse entrou no local de falha
	tile_map_layer.tile_entered.connect(entered)
	mouse_detector.collided.connect(entered)
	# condicao de vitoria
	area_2d_vitoria.mouse_entered.connect(ganhar)

func entered():
	if mouse_detector.collided.is_connected(entered):
		mouse_detector.collided.disconnect(entered)
	collision.set_deferred("disabled", true)
	falhar()

func falhar() -> void:
	falhou.emit()
	#panel_errar.visible = true

func ganhar() -> void:
	ganhou.emit()
