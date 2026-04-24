extends Area2D

signal colided

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	colided.emit(area)
	print("colidiu com: ", area.name)

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
