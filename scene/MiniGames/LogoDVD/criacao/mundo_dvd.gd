class_name DVDMundo
extends Node2D

signal completo
signal click_errado

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
		item.clicado.connect(item_clicado.bind(item))
		# calcula a posicao inicial
		var bounds = itens.position / 2
		item.position = Vector2(
			randf_range(-bounds.x, bounds.x),
			randf_range(-bounds.y, bounds.y)
		)

func item_clicado(item : DVDItemMovendo) -> void:
	lista_itens.erase(item)
	item.queue_free()
	# se nao tiver mais nenhum item, entao completou o mini game
	if lista_itens.is_empty():
		completo.emit()
		return
	# aumenta as velocidades dos outros
	for outro_item : DVDItemMovendo in lista_itens:
		outro_item.aumentar_velocidade()

## Deve ser chamado quando o mouse for clicado
## [br] Verifica o local do click e se foi em um item movimentacao,
## se for remove aquele item, se nao for emite click_errado
## [br] Deve ser chamado somente se o click for dentro do conteudo da pagina,
## se nao clicar fora do navegador, ou em um anuncio (mesmo que para fechar)
## ira triggar o click errado
func mouse_click() -> void:
	# se nao tiver nenhum item para ser clicado, pare
	if lista_itens.is_empty(): return
	
	# pega as posicoes do mouse e da caixa (botao de fechar item)
	var mouse_position = get_global_mouse_position()
	# passa por todos os itens
	var item_selecionado: DVDItemMovendo = null
	for item: DVDItemMovendo in lista_itens:
		if item.clicou_dentro(mouse_position):
			item_selecionado = item
			break
	if item_selecionado:
		item_clicado(item_selecionado)
	else:
		click_errado.emit()
