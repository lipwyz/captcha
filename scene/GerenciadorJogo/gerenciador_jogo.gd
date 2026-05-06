class_name GerenciadorJogo
extends Node

@export_group("Game")
@export var lista_mini_games: ListaMiniGamesRes

@export_group("Nodos")
@export var navegador: Navegador
@export var area_trabalho: AreaTrabalho

func _ready() -> void:
	# comeca com o navegador escondido
	navegador.fechar()
	
	# TODO: sugestao colocar a animacao de intro antes de conectar os sinais
	_conectar_sinais()
	
	# iniciar as abas de teste do navegador
	iniciar_abas()



# TODO: funcoes temporarias
func iniciar_abas() -> void:
	# cria a aba inicial
	criar_aba_inicial()
	iniciar_minigames()

func criar_aba_inicial() -> void:
	var mini_game_abode : MiniGameRes = load("uid://xid604ljsui1")
	var aba_abode := mini_game_abode.criar_aba()
	navegador.add_aba(aba_abode, mini_game_abode.conteudo)
	## coloca essa aba como a padrao
	navegador.aba_padrao = aba_abode
	navegador.atual_aba = aba_abode

func iniciar_minigames() -> void:
	for mg_res: MiniGameRes in lista_mini_games.lista_faceis:
		mg_res.navegador_add_mini_game(navegador)

# -----------------------------------------------------------------------------
# Conectar os sinais
# -----------------------------------------------------------------------------
func _conectar_sinais() -> void:
	area_trabalho.click_navegador.connect(_abrir_navegador)

func _abrir_navegador() -> void:
	navegador.abrir()
