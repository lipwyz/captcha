extends Node

@onready var navegador: Navegador = $Navegador

func _ready() -> void:
	# comeca com o navegador escondido
	navegador.fechar()
	# cria as abas de teste
	test_abas()

func test_abas() -> void:
	# aba 1
	var aba_abode := Aba.criar_aba("Abode", false, Aba.Estados.Idle, "https://Abode.com/inscricao/cancelar/com-certeza-vai-dar-bom.com")
	navegador.add_aba(aba_abode)
	navegador.set_conteudo_aba(aba_abode, load("res://scene/Navegador/conteudoTeste/Conteudo1.tscn"))
	## coloca essa aba como a padrao
	navegador.aba_padrao = aba_abode
	navegador.atual_aba = aba_abode
	
	# aba 2
	var aba_2 := Aba.criar_aba("Aba 2", false, Aba.Estados.Idle, "https://site-muito-maneiro.com.br")
	navegador.add_aba(aba_2)
	navegador.set_conteudo_aba(aba_2, load("res://scene/Navegador/conteudoTeste/Conteudo2.tscn"))
	# aba 3
	var aba_3 := Aba.criar_aba("Aba 3", false, Aba.Estados.Idle, "https://gamelab-so-tem-goat.com")
	navegador.add_aba(aba_3)
	navegador.set_conteudo_aba(aba_3, load("res://scene/Navegador/conteudoTeste/Conteudo3.tscn"))
