class_name GerenciadorJogo
extends Node

@export_group("Abobe")
@export var site_abobe_resource: MiniGameRes

@export_group("Nodos")
@export var navegador: Navegador
@export var area_trabalho: AreaTrabalho

@export_group("Gerenciadores")
@export var gerenciador_mini_games: GerenciadorMiniGames
@export var gerenciador_cut_scene_inicial: GerenciadorCutSceneInicial
@export var gerenciador_anuncios: GerenciadorAnuncios

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scene/MainMenu/main_menu.tscn")

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
	gerenciador_mini_games.ganhou_minigame.connect(proximo_mini_game)
	gerenciador_mini_games.perdeu_minigame.connect(perder_mini_game)

# -----------------------------------------------------------------------------
# Mini Games
# -----------------------------------------------------------------------------

func iniciar_mini_games() -> void:
	gerenciador_mini_games.iniciar_mini_games(navegador)

func proximo_mini_game() -> void:
	iniciar_mini_games()

func perder_mini_game() -> void:
	navegador.fechar_todas_abas_exceto_padrao()

# -----------------------------------------------------------------------------
# Area Trabalho
# -----------------------------------------------------------------------------
func _area_trabalho_conectar_sinais() -> void:
	area_trabalho.click_navegador.connect(_abrir_navegador)

func _abrir_navegador() -> void:
	navegador.abrir()
