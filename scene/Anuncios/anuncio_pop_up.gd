class_name AnuncioPopUp
extends Window

signal fechado

@export var botao_fechar : Button
@export var local_imagem: Control
@export var panel_container: PanelContainer

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
	local_imagem.add_child(imagem_anuncio)
	imagem_anuncio.position = Vector2.ZERO
	# resize a imagem
	imagem_anuncio_size = _resize_tamanho_max(imagem_anuncio)
	# resize a window
	_resize_tamanho_window(imagem_anuncio_size)
	# posiciona o X em alguma posicao da imagem
	_ajustar_botao_fechar(imagem_anuncio_size)

## Ajusta a posicao do botao de fechar dentro da janela
func _ajustar_botao_fechar(_imagem_anuncio_size: Vector2) -> void:
	# decide se o botao fica na esq ou dir
	var esq : bool = randi_range(0, 1) == 0
	if esq:
		# orientacao da esquerda -> direita
		panel_container.layout_direction = Control.LAYOUT_DIRECTION_LTR
	else:
		# orientacao da direita -> esquerda
		panel_container.layout_direction = Control.LAYOUT_DIRECTION_RTL
	return

## Ajusta o tamanho da janela para o mesmo da imagem
func _resize_tamanho_window(_imagem_anuncio_size: Vector2) -> void:
	var _size = _imagem_anuncio_size
	#_size.y += local_imagem.position.y
	_size.y += panel_container.size.y
	size = _size

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
