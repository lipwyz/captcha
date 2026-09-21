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

## [b]Lista de minigames nao completados (mini games em execucao) [/b][br]
## Mini game ao ser criado no navegador, adicionado a essa lista. [br]
## Quando um mini for completo, ele sera removido dessa lista. [br]
## [br][i]
## Entao mini games nessa lista, ainda estao sendo interagidos. [br]
## E mini games que nao estao podem ser considerados como ja foram passados,
## que o jogador nao precisa mais interagir com eles [/i]
var mini_games_nao_completados : Array[ConteudoAba]


func _ready() -> void:
	_reset_mini_games(ListaMiniGamesRes.Dificuldade.FACIL)

# -----------------------------------------------------------------------------
# Lista de Mini games
# -----------------------------------------------------------------------------

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

## Pega um mini game da lista, cria e adiciona como nova aba do navegador
## e conecta os sinais do mini game
func iniciar_mini_games(navegador: Navegador) -> void:
	var minigame_res : MiniGameRes = _get_mini_game(ListaMiniGamesRes.Dificuldade.FACIL)
	var conteudo_aba : ConteudoAba = minigame_res.navegador_add_mini_game(navegador)
	# conecta os sinais
	_conectar_sinais_mini_game(conteudo_aba)
	# adiciona na lista de mini games nao completados
	mini_games_nao_completados.append(conteudo_aba)

func _conectar_sinais_mini_game(conteudo_aba : ConteudoAba) -> void:
	conteudo_aba.minigame_ganhou.connect(_ganhou_minigame.bind(conteudo_aba))
	conteudo_aba.minigame_perdeu.connect(_perdeu_minigame.bind(conteudo_aba))
	conteudo_aba.minigame_errou.connect(_falhar_minigame.bind(conteudo_aba))

# -----------------------------------------------------------------------------
# Acoes do Mini Game para Sinais
# -----------------------------------------------------------------------------

func _ganhou_minigame(minigame: ConteudoAba) -> void:
	# se minigame estiver na lista de nao completados
	if minigame in mini_games_nao_completados:
		# retira da lista e emite o sinal
		mini_games_nao_completados.erase(minigame)
		ganhou_minigame.emit()

func _perdeu_minigame(minigame: ConteudoAba) -> void:
	# somente se estiver na lista de nao completados
	if minigame in mini_games_nao_completados:
		perdeu_minigame.emit()

func _falhar_minigame(minigame: ConteudoAba) -> void:
	# somente se estiver na lista de nao completados
	if minigame in mini_games_nao_completados:
		pedir_anuncio.emit()
