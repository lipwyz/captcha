extends Node

var navegador_inst : Navegador = null

func set_navegador(nav : Navegador) -> void:
	navegador_inst = nav

func get_navegador() -> Navegador:
	return navegador_inst
