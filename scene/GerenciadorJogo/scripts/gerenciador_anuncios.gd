class_name GerenciadorAnuncios
extends Node

signal anuncio_fechado

@export var tamanho_max := Vector2(600, 400)
@export var anuncios_ref: PackedScene
@export var lista_imagens_anuncios: Array[PackedScene]

@onready var anuncios_pai: Control = $AnunciosMargin/AnunciosPai

## Index da cena atual na lista_imagens_anuncios 
var _curr_imagem_id: int = 0

var anuncios_sendo_mostrandos: Array = []

func _ready() -> void:
	lista_imagens_anuncios.shuffle()

## Cria um anuncio para mostrar na tela
func spawnar_anuncio() -> void:
	var anuncio : AnuncioPopUp = anuncios_ref.instantiate()
	var imagem: ImagemAnuncio = _criar_imagem_anuncio()
	# inicia o anuncio
	anuncio.iniciar(imagem, tamanho_max)
	anuncio.fechado.connect(fechar_anuncio)
	anuncios_pai.add_child(anuncio)
	
	anuncios_sendo_mostrandos.append('')
	# TODO: Criar o anuncio

## Fecha anuncio, e emite sinal anuncio_fechado
func fechar_anuncio() -> void:
	anuncios_sendo_mostrandos.erase('')
	anuncio_fechado.emit()
	# TODO: deletar o anuncio (ou fazer object pooling)

## Retona true sem tem anuncios sendo mostrados
func tem_anuncios_sendo_mostrados() -> bool:
	return not anuncios_sendo_mostrandos.is_empty()

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
