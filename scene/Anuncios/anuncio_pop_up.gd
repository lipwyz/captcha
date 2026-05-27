class_name AnuncioPopUp
extends Window

signal fechado

@export var botao_fechar : Button

## tamanho maximo que a imagem / janela do anuncio deve ter
var tamanho_max := Vector2.ONE
## tamanho atual da imagem do anuncio
var imagem_anuncio_size := Vector2.ONE

func _ready() -> void:
	# conectar os sinais
	botao_fechar.pressed.connect(func(): fechado.emit() )

## Inicia a janela de anuncio,
##		imagem_anuncio um nodo do tipo ImagemAnuncio, contendo a imagem
##		_tamanho_max a tamanho maximo que a imagem deve ter
func iniciar(imagem_anuncio: ImagemAnuncio, _tamanho_max: Vector2) -> void:
	tamanho_max = _tamanho_max
	add_child(imagem_anuncio)
	# resize a imagem
	imagem_anuncio_size = _resize_tamanho_max(imagem_anuncio)
	# resize a window
	_resize_tamanho_window(imagem_anuncio_size)
	# posiciona o X em alguma posicao da imagem
	_ajustar_botao_fechar(imagem_anuncio_size)

## Ajusta a posicao do botao de fechar dentro da janela
func _ajustar_botao_fechar(_imagem_anuncio_size: Vector2) -> void:
	# posicao minimas e maximas dentro da janela
	var min_pos := Vector2.ZERO
	var max_pos := Vector2(
		_imagem_anuncio_size.x - botao_fechar.size.x,
		_imagem_anuncio_size.y - botao_fechar.size.y
	)
	# posicao aleatoria dentro do min e max
	var pos_x := randf_range(min_pos.x, max_pos.x)
	var pos_y := randf_range(min_pos.y, max_pos.y)
	botao_fechar.position = Vector2(pos_x, pos_y)
	# move para frente da janela para poder ser clicado
	botao_fechar.move_to_front()

## Ajusta o tamanho da janela para o mesmo da imagem
func _resize_tamanho_window(_imagem_anuncio_size: Vector2) -> void:
	size = _imagem_anuncio_size

## Ajusta o tamanho maximo da imagem para ficar dentro de tamanho_max
##		Retorna o tamanho da imagem apos sofrer o scale
func _resize_tamanho_max(imagem_anuncio: ImagemAnuncio) -> Vector2:
	var _size = imagem_anuncio.get_tamanho_sprite()
	if _size.y > tamanho_max.y:
		imagem_anuncio.scale = Vector2.ONE * (tamanho_max.y / _size.y)
		# atualiza o _size
		_size = _size * (tamanho_max.y / _size.y)
	if _size.x > tamanho_max.x:
		imagem_anuncio.scale = Vector2.ONE * (tamanho_max.x / _size.x)
		# atualiza o _size
		_size = _size * (tamanho_max.x / _size.x)
	return _size

func posicionar(posicao: Vector2) -> void:
	position = posicao
