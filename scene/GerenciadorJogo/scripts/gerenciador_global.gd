extends Node

signal todos_anuncios_fechados

var navegador: Navegador
var gerenciador_jogo : GerenciadorJogo :
	set(_gerenciador_jogo):
		gerenciador_jogo = _gerenciador_jogo
		_ready_gerenciador()

func _ready_gerenciador() -> void:
	gerenciador_jogo.gerenciador_anuncios.todos_anuncios_fechados.connect(
		func(): todos_anuncios_fechados.emit()
	)

func pedir_criar_aba(mini_game_res: MiniGameRes, fechavel: bool = false) -> void:
	var conteudo_aba : ConteudoAba
	conteudo_aba = mini_game_res.navegador_add_mini_game_editado(navegador, fechavel)

func pedir_iniciar_mini_games() -> void:
	gerenciador_jogo.iniciar_mini_games()
