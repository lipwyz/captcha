extends Node

var navegador: Navegador
var gerenciador_jogo : GerenciadorJogo

func pedir_criar_aba(mini_game_res: MiniGameRes, fechavel: bool = false) -> void:
	var conteudo_aba : ConteudoAba
	conteudo_aba = mini_game_res.navegador_add_mini_game_editado(navegador, fechavel)

func pedir_iniciar_mini_games() -> void:
	gerenciador_jogo.iniciar_mini_games()
