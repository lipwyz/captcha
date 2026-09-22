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
@export var gerenciador_pontuacao: GerenciadorPontuacao

@export_group("Valores")
## Quantidade de mini games completos necessaria para terminar a Run
@export var qtde_mini_games_completos_terminar : int = 10

## Jogo esta acontecendo atualmente?
## True em 'iniciar_o_jogo'
## False em '_terminar_o_jogo'
var esta_acontecendo_jogo : bool = false

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
# Jogo - Sequencia de mini games
# -----------------------------------------------------------------------------

## Chamado quando for para iniciar o jogo,
## mostrando o primeiro mini game, dando sequencia aos multiplos mini games
func iniciar_o_jogo() -> void:
	esta_acontecendo_jogo = true
	# comeca o primeiro mini game
	gerenciador_mini_games.zerar_valores()
	gerenciador_mini_games.comecar_mini_game(navegador)
	# inicia a contagem da pontuacao
	gerenciador_pontuacao.iniciar_contagem()

func _terminar_o_jogo() -> void:
	# se nao tiver mais acontecendo, nao tem o que terminar, pare
	if not esta_acontecendo_jogo: return
	
	# marca que o jogo terminou
	esta_acontecendo_jogo = false
	# para de contar os pontos
	gerenciador_pontuacao.parar_contagem()
	# TODO: tela de fim de jogo
	print("tempo_total_segundos: ", gerenciador_pontuacao.tempo_total_segundos)
	print("mini_games_ganhos: ",    gerenciador_pontuacao.mini_games_ganhos)
	print("anuncios_spawnados: ",   gerenciador_pontuacao.anuncios_spawnados)


# -----------------------------------------------------------------------------
# Gerenciadores
# -----------------------------------------------------------------------------

func _gerenciadores_conectar_sinais() -> void:
	gerenciador_mini_games.ganhou_minigame.connect(_proximo_mini_game)
	gerenciador_mini_games.perdeu_minigame.connect(_perder_mini_game)
	gerenciador_mini_games.pedir_anuncio.connect(_spawnar_anuncio)

# Mini Games
# -----------------------------------------------------------------------------

func _proximo_mini_game() -> void:
	# se completou a quantidade necessaria para terminar o jogo, termine e pare
	if gerenciador_mini_games.mini_games_completados_qtde >= qtde_mini_games_completos_terminar:
		_terminar_o_jogo()
		return
	# se tiver mais mini games, crie outro mini game
	gerenciador_mini_games.comecar_mini_game(navegador)
	# marca na pontuacao
	gerenciador_pontuacao.marcar_ganhou_mini_game()

func _perder_mini_game() -> void:
	navegador.fechar_todas_abas_exceto_padrao()

# Anuncios
# -----------------------------------------------------------------------------

func _spawnar_anuncio() -> void:
	gerenciador_anuncios.spawnar_anuncio()
	gerenciador_pontuacao.marcar_spawnou_anuncio()

# -----------------------------------------------------------------------------
# Area Trabalho
# -----------------------------------------------------------------------------
func _area_trabalho_conectar_sinais() -> void:
	area_trabalho.click_navegador.connect(_abrir_navegador)

func _abrir_navegador() -> void:
	navegador.abrir()
