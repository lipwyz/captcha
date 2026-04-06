class_name Navegador
extends Control

@onready var navegador_controles: NavegadorControles = $Panel/VSplit/NavegadorControles
@onready var navegador_conteudo: NavegadorConteudo = $Panel/VSplit/NavegadorConteudo
@onready var conteudos_abas_minimizadas: Control = $ConteudosAbasMinimizadas

@export var aba_padrao : Aba
var atual_aba : Aba = null

# abrir navegador pelo app do desktop
func abrir() -> void:
	show()

# fechar o navegador e voltar pro desktop
#	(nao precisamos fechar realmente, so esconder)
func fechar() -> void:
	hide()

func _ready() -> void:
	# garante que abas minimizadas nao sao visiveis
	conteudos_abas_minimizadas.hide()
	
	# TODO: verificar de fechar e de minimizar
	# conecta o sinal de fechar o navegador (ao apertar o botao)
	#	na func fechar()
	navegador_controles.fechar.connect(fechar)
	# conecta o sinal de minimizar para fechar o navegador tb
	navegador_controles.minimizar.connect(fechar)

## funcao que sai da aba anterior, e display o conteudo da aba atual
func mudar_aba(nova_aba : Aba) -> void:
	# sai da aba anterior
	#	mudar o display da aba, para refletir que saiu dela
	atual_aba.sair_aba()
	
	atual_aba = nova_aba
	# entra na nova aba
	nova_aba.entrar_aba()
	# muda o url para o da aba
	navegador_controles.mudar_url(nova_aba.texto_url)
	
	# load conteudo da nova aba
	navegador_conteudo.mostrar_conteudo(nova_aba)

## adiciona uma aba no navegador
func add_aba(aba : Aba) -> void:
	# conecta os sinais da aba
	aba.clicada.connect(mudar_aba.bind(aba))
	aba.fechada.connect(deletar_aba.bind(aba))
	# adiciona na tree e visualmente no jogo
	navegador_controles.add_aba(aba)

## coloca o conteudo que vai ser mostrado em uma aba
func set_conteudo_aba(aba : Aba, conteudo_ref : PackedScene) -> void:
	navegador_conteudo.criar_conteudo(aba, conteudo_ref)

## fecha a aba, removendo o conteudo dela
func deletar_aba(aba : Aba) -> void:
	mudar_aba(aba_padrao)
	navegador_conteudo.liberar_conteudo_aba(aba)
	aba.queue_free()
	
