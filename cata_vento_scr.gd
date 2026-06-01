extends Area2D

@export var velocity: float = 0.04
## signal colided

func _ready() -> void:
	##mouse_entered.connect(_on_mouse_entered)
	pass

func _on_mouse_entered():
	##colided.emit() 
	##print("colococec")
	pass

func _physics_process(delta: float) -> void:
	rotate(velocity)
