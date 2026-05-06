extends Node

var navegador: Navegador

func pedir_criar_aba(mini_game_res: MiniGameRes, fechavel: bool = false) -> void:
	mini_game_res.navegador_add_mini_game_editado(navegador, fechavel)
