extends Node

@onready var navegador: Navegador = $Navegador

func _ready() -> void:
	GameGerenciador.set_navegador(navegador)
	
	# comeca com o navegador escondido
	navegador.fechar()
	# cria a aba inicial
	criar_aba_inicial()
	# cria as abas de teste
	navegador.aberto.connect(test_abas)

func criar_aba_inicial() -> void:
	var mini_game_abode : MiniGameRes = load("uid://xid604ljsui1")
	var aba_abode := mini_game_abode.criar_aba()
	navegador.add_aba(aba_abode, mini_game_abode.conteudo)
	## coloca essa aba como a padrao
	navegador.aba_padrao = aba_abode
	navegador.atual_aba = aba_abode

var test_abas_criadas := false
func test_abas() -> void:
	if test_abas_criadas: return
	test_abas_criadas = true
	
	# TODO: isso funciona por enquanto, 
	#	mas trabalhar com instanciar as cenas dps de criar o navegador eh uma play melhor
	await get_tree().process_frame
	GameGerenciador.set_size_conteudo_navegador(navegador.navegador_conteudo.panel_conteudo.size)
	
	
	# aba 2
	var mini_game_2 : MiniGameRes = load("uid://c7tjim70hbg0b")
	mini_game_2.navegador_add_mini_game(navegador)
	# aba 3
	var mini_game_3 : MiniGameRes = load("uid://c4jo8i3ff08nm")
	mini_game_3.navegador_add_mini_game(navegador)
	# aba 4 - Bario World
	var mini_game_4 : MiniGameRes = load("uid://b4cu5kbxiwxwn")
	mini_game_4.navegador_add_mini_game(navegador)
	
	# aba 6 - Selecionar quadrados
	var mini_game_6 : MiniGameRes = load("uid://c8lyg2jjrh1j2")
	mini_game_6.navegador_add_mini_game(navegador)
