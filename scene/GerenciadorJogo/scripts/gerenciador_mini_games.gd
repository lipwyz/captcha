class_name GerenciadorMiniGames
extends Node

signal ganhou_minigame
signal perdeu_minigame
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
	conteudo_aba.minigame_ganhou.connect(_ganhou_minigame)
	conteudo_aba.minigame_perdeu.connect(_perdeu_minigame)
	conteudo_aba.minigame_errou.connect(_falhar_minigame)

# -----------------------------------------------------------------------------
# Acoes do Mini Game
# -----------------------------------------------------------------------------

func _ganhou_minigame() -> void:
	ganhou_minigame.emit()

func _perdeu_minigame() -> void:
	perdeu_minigame.emit()

func _falhar_minigame() -> void:
	pedir_anuncio.emit()
	
