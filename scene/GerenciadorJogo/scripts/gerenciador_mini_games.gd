class_name GerenciadorMiniGames
extends Node

@export_group("Game")
@export var lista_mini_games: ListaMiniGamesRes

func iniciar_mini_games(navegador: Navegador) -> void:
	var mg_res : MiniGameRes = lista_mini_games.lista_faceis.pick_random()
	mg_res.navegador_add_mini_game(navegador)
