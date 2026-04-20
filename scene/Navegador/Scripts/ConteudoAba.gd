extends Control
class_name ConteudoAba

signal terminado

func terminar() -> void:
	emit_signal("terminado")
