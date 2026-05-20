class_name GerenciadorJogo
extends Node

@export_group("Abobe")
@export var site_abobe_resource: MiniGameRes

@export_group("Nodos")
@export var navegador: Navegador
@export var area_trabalho: AreaTrabalho

@onready var gerenciador_mini_games: GerenciadorMiniGames = $GerenciadorMiniGames
@onready var gerenciador_cut_scene_inicial: GerenciadorCutSceneInicial = $GerenciadorCutSceneInicial
@onready var gerenciador_anuncios: GerenciadorAnuncios = $GerenciadorAnuncios

func _ready() -> void:
	GerenciadorGlobal.gerenciador_jogo = self
	GerenciadorGlobal.navegador = navegador
	
	_gerenciadores_conectar_sinais()
	
	_ready_area_trabalho()
	

func _ready_area_trabalho() -> void:
	# comeca com o navegador escondido
	navegador.fechar()
	GerenciadorGlobal.navegador = navegador
	
	await get_tree().process_frame
	gerenciador_cut_scene_inicial.iniciar_cutscene(navegador, area_trabalho)
	
	# TODO: sugestao colocar a animacao de intro antes de conectar os sinais
	_area_trabalho_conectar_sinais()
	
	# cria a aba inicial do navegador
	criar_aba_inicial()


func criar_aba_inicial() -> void:
	var aba_abode := site_abobe_resource.criar_aba()
	navegador.add_aba(aba_abode, site_abobe_resource.conteudo)
	## coloca essa aba como a padrao
	navegador.aba_padrao = aba_abode

# -----------------------------------------------------------------------------
# Gerenciadores
# -----------------------------------------------------------------------------

func _gerenciadores_conectar_sinais() -> void:
	gerenciador_mini_games.pedir_anuncio.connect(gerenciador_anuncios.spawnar_anuncio)

# -----------------------------------------------------------------------------
# Mini Games
# -----------------------------------------------------------------------------

func iniciar_mini_games() -> void:
	gerenciador_mini_games.iniciar_mini_games(navegador)

# -----------------------------------------------------------------------------
# Area Trabalho
# -----------------------------------------------------------------------------
func _area_trabalho_conectar_sinais() -> void:
	area_trabalho.click_navegador.connect(_abrir_navegador)

func _abrir_navegador() -> void:
	navegador.abrir()
