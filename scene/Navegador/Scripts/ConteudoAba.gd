class_name ConteudoAba
extends Control

signal terminado

func terminar() -> void:
	terminado.emit()
