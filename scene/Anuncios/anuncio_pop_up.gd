class_name AnuncioPopUp
extends Window

signal fechado

@export var botao_x : Button

var tamanho_max := Vector2.ONE
var imagem_anuncio_size := Vector2.ONE

func _ready() -> void:
	botao_x.pressed.connect(func(): fechado.emit() )

func iniciar(imagem_anuncio: ImagemAnuncio, _tamanho_max: Vector2) -> void:
	add_child(imagem_anuncio)
	tamanho_max = _tamanho_max
	# resize a imagem
	imagem_anuncio_size = _resize_tamanho_max(imagem_anuncio)
	# resize a window
	_resize_tamanho_window(imagem_anuncio_size)
	# posiciona o X em alguma posicao da imagem
	_ajustar_botao_x(imagem_anuncio_size)

func _ajustar_botao_x(imagem_anuncio_size: Vector2) -> void:
	var max_size := Vector2(
		imagem_anuncio_size.x - botao_x.size.x,
		imagem_anuncio_size.y - botao_x.size.y
	)
	var pos_x := randf_range(0, max_size.x)
	var pos_y := randf_range(0, max_size.y)
	botao_x.position = Vector2(pos_x, pos_y)
	botao_x.move_to_front()

func _resize_tamanho_window(imagem_anuncio_size: Vector2) -> void:
	size = imagem_anuncio_size

func _resize_tamanho_max(imagem_anuncio: ImagemAnuncio) -> Vector2:
	var _size = imagem_anuncio.get_tamanho_sprite()
	print("_size", _size)
	if _size.y > tamanho_max.y:
		imagem_anuncio.scale = Vector2.ONE * (tamanho_max.y / _size.y)
		# atualiza o _size
		_size = _size * (tamanho_max.y / _size.y)
		#return _size
		print("_size.y _size", _size)
	if _size.x > tamanho_max.x:
		imagem_anuncio.scale = Vector2.ONE * (tamanho_max.x / _size.x)
		#_size = Vector2.ONE * (tamanho_max.x / _size.x)
		_size = _size * (tamanho_max.x / _size.x)
		print("_size.x _size", _size)
		#return _size
	return _size
