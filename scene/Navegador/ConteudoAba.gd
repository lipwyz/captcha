extends Node
class_name ConteudoAba

signal terminado

func terminar(arg : String = "") -> void:
	emit_signal("terminado", arg)
