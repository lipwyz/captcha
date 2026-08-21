class_name DVDMundo
extends Node2D

signal completo
signal anuncio ## TODO: Nao esta sendo utilizado

@export var qtde_item_movendo := 4

@onready var itens: Node2D = $Itens

const ITEM_MOVENDO = preload("uid://byktb26gt0ak3")

var lista_itens : Array[DVDItemMovendo] = []

func _ready() -> void:
	for i in range(qtde_item_movendo):
		# cria o item
		var item : DVDItemMovendo = ITEM_MOVENDO.instantiate()
		itens.add_child(item)
		lista_itens.append(item)
		# sinais
		item.clicado.connect(clicado.bind(item))
		# calcula a posicao inicial
		var bounds = itens.position / 2
		item.position = Vector2(
			randf_range(-bounds.x, bounds.x),
			randf_range(-bounds.y, bounds.y)
		)

func clicado(item : DVDItemMovendo) -> void:
	lista_itens.erase(item)
	item.queue_free()
	# se nao tiver mais nenhum item, entao completou o mini game
	if lista_itens.is_empty():
		completo.emit()
		return
	# aumenta as velocidades dos outros
	for outro_item : DVDItemMovendo in lista_itens:
		outro_item.aumentar_velocidade()
