extends Node

var navegador_inst : Navegador = null

func set_navegador(nav : Navegador) -> void:
	navegador_inst = nav

func get_navegador() -> Navegador:
	return navegador_inst

# TODO: melhorar essa funcao, pra n ser tao especifica assim
var _size_conteudo_navegador := Vector2.ONE
signal resize_conteudo_navegador 

func set_size_conteudo_navegador(_size : Vector2) -> void:
	_size_conteudo_navegador = _size
	emit_signal("resize_conteudo_navegador", _size)

func get_size_conteudo_navegador() -> Vector2:
	return _size_conteudo_navegador
