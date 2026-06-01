class_name GerenciadorMiniGames
extends Node

signal pedir_anuncio

@export_group("Game")
@export var lista_mini_games: ListaMiniGamesRes

var listas_por_dificuldade : Dictionary[ListaMiniGamesRes.Dificuldade, Array] = {
	ListaMiniGamesRes.Dificuldade.FACIL:   [],
	ListaMiniGamesRes.Dificuldade.MEDIO:   [],
	ListaMiniGamesRes.Dificuldade.DIFICIL: [],
} 


func _ready() -> void:
	_reset_mini_games(ListaMiniGamesRes.Dificuldade.FACIL)

## Reseta a lista de minigames de uma dada dificuldade, embaralhando
func _reset_mini_games(dificuldade: ListaMiniGamesRes.Dificuldade) -> void:
	var lista : Array[MiniGameRes]
	match (dificuldade):
		ListaMiniGamesRes.Dificuldade.FACIL:
			lista = lista_mini_games.lista_faceis.duplicate()
		ListaMiniGamesRes.Dificuldade.MEDIO:
			lista = lista_mini_games.lista_medios.duplicate()
		ListaMiniGamesRes.Dificuldade.DIFICIL:
			lista = lista_mini_games.lista_dificeis.duplicate()
	lista.shuffle()
	listas_por_dificuldade[dificuldade] = lista

## Retona um MiniGameRes para dada dificuldade.
##	Nao repete elementos ate a lista acabar, entao re-embaralha
func _get_mini_game(dificuldade: ListaMiniGamesRes.Dificuldade) -> MiniGameRes:
	if listas_por_dificuldade[dificuldade].is_empty():
		_reset_mini_games(dificuldade)
	return listas_por_dificuldade[dificuldade].pop_back()



# -----------------------------------------------------------------------------
# Iniciar Mini game
# -----------------------------------------------------------------------------

## 
func iniciar_mini_games(navegador: Navegador) -> void:
	var minigame_res : MiniGameRes = _get_mini_game(ListaMiniGamesRes.Dificuldade.FACIL)
	var conteudo_aba : ConteudoAba = minigame_res.navegador_add_mini_game(navegador)
	_conectar_sinais_mini_game(conteudo_aba)

func _conectar_sinais_mini_game(conteudo_aba : ConteudoAba) -> void:
	conteudo_aba.minigame_ganhou.connect(func(): print("terminado") )
	#conteudo_aba.minigame_perdeu.connect(_falhar_mini_game)
	conteudo_aba.minigame_errou.connect(_falhar_mini_game)

# -----------------------------------------------------------------------------
# Acoes do Mini Game
# -----------------------------------------------------------------------------

func _falhar_mini_game() -> void:
	pedir_anuncio.emit()
