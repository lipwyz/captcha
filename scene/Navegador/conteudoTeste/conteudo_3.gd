class_name Conteudo3
extends Control

signal completada

@onready var area_2d: Area2D = $Node2D/Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entrou ", body)
	area_2d.queue_free()
	emit_signal("completada")
