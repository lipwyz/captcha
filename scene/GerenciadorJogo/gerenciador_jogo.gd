class_name GerenciadorJogo
extends Node

@export_group("Game")
@export var lista_mini_games: ListaMiniGamesRes

@export_group("CutScene")
@export var cena_cutscene: PackedScene
@export var cena_cutscene_2: PackedScene

@export_group("Nodos")
@export var navegador: Navegador
@export var area_trabalho: AreaTrabalho

func _ready() -> void:
	GerenciadorGlobal.navegador = navegador
	# comeca com o navegador escondido
	navegador.fechar()
	
	await get_tree().process_frame
	iniciar_cutscene()
	
	# TODO: sugestao colocar a animacao de intro antes de conectar os sinais
	_conectar_sinais()
	
	# iniciar as abas de teste do navegador
	iniciar_abas()


func iniciar_cutscene() -> void:
	var aba_cutscene := Aba.criar_aba(
			"TwiXer",
			false,
			Aba.Estados.Idle,
			"TwiXer/forYou")
	navegador.add_aba(aba_cutscene, cena_cutscene)
	
	# TODO: inicar a cut scene
	var nav_cont = navegador.navegador_conteudo
	var teste_cutscene = nav_cont.conteudo_por_aba[aba_cutscene]
	#if teste_cutscene is TestCutScene:
		#aba_cutscene.clicada.connect(
			#func():
				#teste_cutscene.iniciar_cutscene()
		#)
	
	# -------------
	#var aba_cutscene_2 := Aba.criar_aba(
			#"TwiXer 2",
			#false,
			#Aba.Estados.Idle,
			#"TwiXer/forYou")
	#navegador.add_aba(aba_cutscene_2, cena_cutscene_2)
	#var teste_cutscene_2 = nav_cont.conteudo_por_aba[aba_cutscene_2]
	#aba_cutscene_2.clicada.connect(func(): teste_cutscene_2.iniciar_cutscene() )
	
	# Ajustar a aba inicial
	navegador.mudar_aba(aba_cutscene)
	# TODO: mudar essa inicializacao
	area_trabalho.click_navegador.connect(_iniciar_cutscene.bind(teste_cutscene))

func _iniciar_cutscene(teste_cutscene: TestCutScene) -> void:
	area_trabalho.click_navegador.disconnect(_iniciar_cutscene)
	#await get_tree().create_timer(0.2).timeout
	teste_cutscene.iniciar_cutscene()


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
