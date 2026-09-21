extends Node

signal todos_anuncios_fechados

var navegador: Navegador
var gerenciador_jogo : GerenciadorJogo :
	set(_gerenciador_jogo):
		gerenciador_jogo = _gerenciador_jogo
		_ready_gerenciador()

# Ao apertar volta para o MainMenu ao apertar ESC
# TODO: obs: realiza o 'change scene' mesmo se ja estiver no mainMenu
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("uid://cbrpvi6rnvw0i")

## Chamado automaticamento quando o gerenciador_jogo eh ajustado
## [br] Conecta o sinal de todos_anuncios_fechados do gerenciador anuncios
## para emitir todos_anuncios_fechados
func _ready_gerenciador() -> void:
	gerenciador_jogo.gerenciador_anuncios.todos_anuncios_fechados.connect(
		func(): todos_anuncios_fechados.emit()
	)


func pedir_criar_aba(mini_game_res: MiniGameRes, fechavel: bool = false) -> void:
	var conteudo_aba : ConteudoAba
	conteudo_aba = mini_game_res.navegador_add_mini_game_editado(navegador, fechavel)

func pedir_iniciar_mini_games() -> void:
	gerenciador_jogo.iniciar_mini_games()
