class_name GerenciadorJogo
extends Node

@export_group("Abobe")
@export var site_abobe_resource: MiniGameRes

@export_group("Nodos")
@export var navegador: Navegador
@export var area_trabalho: AreaTrabalho

@onready var gerenciador_mini_games: GerenciadorMiniGames = $GerenciadorMiniGames
@onready var gerenciador_cut_scene_inicial: GerenciadorCutSceneInicial = $GerenciadorCutSceneInicial

func _ready() -> void:
	GerenciadorGlobal.gerenciador_jogo = self
	GerenciadorGlobal.navegador = navegador
	
	# comeca com o navegador escondido
	navegador.fechar()
	
	await get_tree().process_frame
	gerenciador_cut_scene_inicial.iniciar_cutscene(navegador, area_trabalho)
	
	# TODO: sugestao colocar a animacao de intro antes de conectar os sinais
	_conectar_sinais()
	
	# iniciar as abas de teste do navegador
	iniciar_abas()


# TODO: funcoes temporarias
func iniciar_abas() -> void:
	# cria a aba inicial
	criar_aba_inicial()

func criar_aba_inicial() -> void:
	var aba_abode := site_abobe_resource.criar_aba()
	navegador.add_aba(aba_abode, site_abobe_resource.conteudo)
	## coloca essa aba como a padrao
	navegador.aba_padrao = aba_abode


# -----------------------------------------------------------------------------
# Mini Games
# -----------------------------------------------------------------------------

func iniciar_mini_games() -> void:
	gerenciador_mini_games.iniciar_mini_games(navegador)

#func iniciar_minigames() -> void:
	#for mg_res: MiniGameRes in lista_mini_games.lista_faceis:
		#mg_res.navegador_add_mini_game(navegador)

# -----------------------------------------------------------------------------
# Conectar os sinais
# -----------------------------------------------------------------------------
func _conectar_sinais() -> void:
	area_trabalho.click_navegador.connect(_abrir_navegador)

func _abrir_navegador() -> void:
	navegador.abrir()
