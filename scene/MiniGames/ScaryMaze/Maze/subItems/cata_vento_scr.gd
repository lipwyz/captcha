extends StaticBody2D

@export var velocity: float = 1.0

func _physics_process(delta: float) -> void:
	rotate(velocity * delta)
