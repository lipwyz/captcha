class_name ConteudoAba
extends Control

signal terminado
signal falha

func terminar() -> void:
	terminado.emit()

func falhar() -> void:
	falha.emit()
