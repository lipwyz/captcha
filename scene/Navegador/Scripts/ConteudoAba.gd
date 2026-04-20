class_name ConteudoAba
extends Control

signal terminado

func terminar() -> void:
	emit_signal("terminado")
