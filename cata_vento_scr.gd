extends Area2D

@export var velocity: float = 0.04
@onready var controller: Control = $".."

signal colided
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	rotate(velocity)
	pass
	
func entered():
	print("sexo")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.


func mouse_entered() -> void:
	emit_signal("colided")
	print("SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	pass # Replace with function body.
