class_name Navegador
extends Control

@onready var navegador_controles: NavegadorControles = $Panel/VSplit/NavegadorControles
@onready var navegador_conteudo: NavegadorConteudo = $Panel/VSplit/NavegadorConteudo

@export var aba_padrao : Aba
var atual_aba : Aba = null

func abrir() -> void:
	show()

func fechar() -> void:
	hide()

func _ready() -> void:
	# conecta o sinal de fechar o navegador (ao apertar o botao)
	#	na func fechar()
	navegador_controles.fechar.connect(fechar)

# funcao que sai da aba anterior
# 	e display o conteudo da aba atual
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
	navegador_conteudo.mostrar_conteudo(nova_aba.conteudo)

func add_aba(aba : Aba) -> void:
	aba.clicada.connect(mudar_aba.bind(aba))
	aba.fechada.connect(deletar_aba.bind(aba))
	# adiciona na tree e visualmente no jogo
	navegador_controles.add_aba(aba)

func set_conteudo_aba(aba : Aba, conteudo : PackedScene) -> void:
	aba.conteudo = conteudo

func deletar_aba(aba : Aba) -> void:
	mudar_aba(aba_padrao)
	aba.queue_free()
