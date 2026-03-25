extends Node

static var navegador_inst : Navegador = null

static func set_navegador(nav : Navegador) -> void:
	navegador_inst = nav

static func get_navegador() -> Navegador:
	return navegador_inst
