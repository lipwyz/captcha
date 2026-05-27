class_name GerenciadorAnuncios
extends Node

signal anuncio_fechado

@export var tamanho_max := Vector2(600, 400)
@export var anuncios_ref: PackedScene
@export var lista_imagens_anuncios: Array[PackedScene]

@onready var anuncios_mostrados: Control = $AnunciosMargin/AnunciosMostrados
@onready var anuncios_espera: Control = $AnunciosEspera

## Index da cena atual na lista_imagens_anuncios 
var _curr_imagem_id: int = 0

var lista_anuncios_mostrados: Array[AnuncioPopUp] = []
var lista_anuncios_espera: Array = [AnuncioPopUp]

func _ready() -> void:
	lista_imagens_anuncios.shuffle()

## Cria um anuncio para mostrar na tela
func spawnar_anuncio() -> void:
	var anuncio : AnuncioPopUp
	# se puder pegar da lista de espera, pegue
	if _pode_pegar_anuncio_lista_espera():
		anuncio = _pegar_anuncio_lista_espera()
	# se nao puder da lista de espera, crie
	else:
		anuncio = _criar_anuncio()
	# anuncios do anuncio
	lista_anuncios_mostrados.append(anuncio)
	anuncios_mostrados.add_child(anuncio)

func _criar_anuncio() -> AnuncioPopUp:
	var anuncio : AnuncioPopUp = anuncios_ref.instantiate()
	var imagem: ImagemAnuncio = _criar_imagem_anuncio()
	# inicia o anuncio
	anuncio.iniciar(imagem, tamanho_max)
	anuncio.fechado.connect(fechar_anuncio.bind(anuncio))
	
	return anuncio

func _pode_pegar_anuncio_lista_espera() -> bool:
	# nao spawnou um de cada tipo de anuncio ainda, entao nao pegue
	if lista_anuncios_espera.size() <= lista_imagens_anuncios.size():
		return false
	return true

func _pegar_anuncio_lista_espera() -> AnuncioPopUp:
	if lista_anuncios_espera.size() % lista_imagens_anuncios.size() == 0:
		lista_anuncios_espera.shuffle()
	
	var anuncio: AnuncioPopUp = lista_anuncios_espera.pop_back()
	anuncios_espera.remove_child(anuncio)
	#
	anuncio.show()
	anuncio.process_mode = Node.PROCESS_MODE_INHERIT
	#
	return anuncio

## Fecha anuncio, e emite sinal anuncio_fechado
func fechar_anuncio(anuncio: AnuncioPopUp) -> void:
	lista_anuncios_mostrados.erase(anuncio)
	lista_anuncios_espera.append(anuncio)
	#
	anuncio.hide()
	anuncio.process_mode = Node.PROCESS_MODE_DISABLED
	#
	anuncios_mostrados.remove_child(anuncio)
	anuncios_espera.add_child(anuncio)
	#
	anuncio_fechado.emit()

## Retona true sem tem anuncios sendo mostrados
func tem_anuncios_sendo_mostrados() -> bool:
	return not lista_anuncios_mostrados.is_empty()

func _criar_imagem_anuncio() -> ImagemAnuncio:
	# pega a imagem da lista no id atual
	var imagem_ref: PackedScene = lista_imagens_anuncios[_curr_imagem_id]
	# avanca pro proximo id
	_curr_imagem_id += 1
	# se tiver terminado a lista, shuffle e volte pro zero
	if _curr_imagem_id >= lista_imagens_anuncios.size():
		_curr_imagem_id = 0
		lista_imagens_anuncios.shuffle()
	# retona a imagem criada
	return imagem_ref.instantiate()
