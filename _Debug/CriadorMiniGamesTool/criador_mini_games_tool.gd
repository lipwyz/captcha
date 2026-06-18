@tool
class_name CriadorMiniGamesTool
extends Node

@export var tamanho_tela := Vector2(800, 600)

@export_tool_button("Executar", "AcceptDialog") var botao_rodar = _run

var window: Window

const JANELA_CRIADOR_MINI_GAMES = preload("uid://gtsgth0k45ky")

func _run() -> void:
	# cria a janela
	window = Window.new()
	EditorInterface.popup_dialog(
		window,
		Rect2(Vector2.ONE*100, tamanho_tela)
	)
	# lida com fechar
	window.close_requested.connect( (func(x): x.queue_free()).bind(window) )
	
	# adiciona os elementos na janela
	window.add_child(JANELA_CRIADOR_MINI_GAMES.instantiate())
