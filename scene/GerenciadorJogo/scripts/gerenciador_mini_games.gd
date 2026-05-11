class_name GerenciadorMiniGames
extends Node

func iniciar_mini_games() -> void:
	var p : GerenciadorJogo = get_parent()
	var mg_res : MiniGameRes = p.lista_mini_games.lista_faceis.pick_random()
	mg_res.navegador_add_mini_game(p.navegador)
