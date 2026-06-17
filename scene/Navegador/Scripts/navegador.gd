class_name Navegador
extends Control

@onready var navegador_controles: NavegadorControles = $Panel/VSplit/NavegadorControles
@onready var navegador_conteudo: NavegadorConteudo = $Panel/VSplit/NavegadorConteudo
@onready var conteudos_abas_minimizadas: Control = $ConteudosAbasMinimizadas

@export var aba_padrao : Aba
var aba_atual : Aba = null

signal aberto
signal fechado

func _ready() -> void:
	# garante que abas minimizadas nao sao visiveis
	conteudos_abas_minimizadas.hide()
	
	# TODO: verificar de fechar e de minimizar
	# conecta o sinal de fechar o navegador (ao apertar o botao)
	#	na func fechar()
	navegador_controles.fechar.connect(fechar)
	# conecta o sinal de minimizar para fechar o navegador tb
	navegador_controles.minimizar.connect(fechar)

# -----------------------------------------------------------------------------
# Display do Navegador

## Abrir navegador pelo app do desktop
func abrir() -> void:
	show()
	aberto.emit()

## Fechar o navegador e voltar pro desktop
##	(nao precisamos fechar realmente, so esconder)
func fechar() -> void:
	hide()
	fechado.emit()

# -----------------------------------------------------------------------------
# Gerenciamento das Abas

## Funcao que sai da aba anterior, e display o conteudo da aba atual
func mudar_aba(nova_aba : Aba) -> void:
	# se tiver uma aba atual (inicio de jogo nao tem aba atual)
	if aba_atual and is_instance_valid(aba_atual):
		# sai da aba anterior
		#	mudar o display da aba, para refletir que saiu dela
		aba_atual.sair_aba()
	
	aba_atual = nova_aba
	# entra na nova aba
	nova_aba.entrar_aba()
	# muda o url para o da aba
	navegador_controles.mudar_url(nova_aba.texto_url)
	
	# load conteudo da nova aba
	navegador_conteudo.mostrar_conteudo(nova_aba)

## Adiciona uma aba no navegador, com um conetudo
func add_aba(aba : Aba, conteudo_ref : PackedScene) -> void:
	_add_aba_visual(aba)
	_criar_conteudo_aba(aba, conteudo_ref)
	mudar_aba(aba)

## Adiciona a aba visualmente ao navegador e conecta os sinais
func _add_aba_visual(aba : Aba) -> void:
	# conecta os sinais da aba
	aba.clicada.connect(mudar_aba.bind(aba))
	aba.fechada.connect(deletar_aba.bind(aba))
	# adiciona na tree e visualmente no jogo
	navegador_controles.add_aba(aba)

## Coloca o conteudo que vai ser mostrado em uma aba
func _criar_conteudo_aba(aba : Aba, conteudo_ref : PackedScene) -> void:
	navegador_conteudo.criar_conteudo(aba, conteudo_ref)

## Fecha a aba, removendo o conteudo dela
func deletar_aba(aba : Aba) -> void:
	if aba_atual != aba_padrao:
		mudar_aba(aba_padrao)
	navegador_conteudo.liberar_conteudo_aba(aba)
	navegador_controles.remove_aba(aba)

func get_conteudo_aba(aba: Aba) -> ConteudoAba:
	return navegador_conteudo.conteudo_por_aba[aba]

## Fecha todas as abas aberta, exceto a aba padrao
func fechar_todas_abas_exceto_padrao() -> void:
	mudar_aba(aba_padrao)
	for aba: Aba in navegador_controles.abas_list.duplicate():
		if aba != aba_padrao:
			deletar_aba(aba)
