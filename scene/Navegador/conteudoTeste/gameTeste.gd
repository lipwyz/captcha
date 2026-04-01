extends Node

@onready var navegador: Navegador = $Navegador

func _ready() -> void:
	GameGerenciador.set_navegador(navegador)
	
	# comeca com o navegador escondido
	navegador.fechar()
	# cria as abas de teste
	test_abas()

func test_abas() -> void:
	# aba 1
	var mini_game_abode : MiniGameRes = load("res://scene/Navegador/conteudoTeste/miniGame1.tres")
	var aba_abode := mini_game_abode.criar_aba()
	navegador.add_aba(aba_abode)
	navegador.set_conteudo_aba(aba_abode, mini_game_abode.conteudo)
	## coloca essa aba como a padrao
	navegador.aba_padrao = aba_abode
	navegador.atual_aba = aba_abode
	
	# aba 2
	var mini_game_2 : MiniGameRes = load("res://scene/Navegador/conteudoTeste/miniGame2.tres")
	mini_game_2.navegador_add_mini_game(navegador)
	# aba 3
	var mini_game_3 : MiniGameRes = load("res://scene/Navegador/conteudoTeste/miniGame3.tres")
	mini_game_3.navegador_add_mini_game(navegador)
