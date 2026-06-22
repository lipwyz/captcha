class_name MouseDetector
extends Area2D

signal collided

func _ready() -> void:
	area_entered.connect(_on_entered)
	body_entered.connect(_on_entered)

func _on_entered(_area: Node2D) -> void:
	collided.emit()
	#print("colidiu com: ", _area.name)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
