class_name Navegador
extends Control

@onready var h_box_abas: HBoxContainer = $Panel/VSplitControlesConteudo/VBoxControles/MarginAbasBar/HBoxAbas
@onready var panel_conteudo: PanelContainer = $Panel/VSplitControlesConteudo/MarginContainer/PanelConteudo
@onready var label_address: Label = $Panel/VSplitControlesConteudo/VBoxControles/MarginHotBar/PanelHotBar/HBox/PanelAddress/Margin/LabelAddress

const ABA_REF = preload("uid://dxiaud0xsx1he")

var abas_por_titulo : Dictionary[String, Aba] = {}

# ajustados no ready
var atual_aba : Aba = null
var titulo_aba_padrao : String


#############################################
# Tudo aqui esta meio q gambiarra atualmente
############################################
func _ready() -> void:
	# aba atual como a primeira aba da lista
	atual_aba = h_box_abas.get_child(0)
	titulo_aba_padrao = atual_aba.titulo
	
	# para cada aba
	#	conectar o sinal de clicada da aba na funcao 'mudar_aba'
	for aba : Aba in h_box_abas.get_children():
		abas_por_titulo[aba.titulo] = aba
		aba.clicada.connect(mudar_aba.bind(aba))
		

# funcao que sai da aba anterior
# 	e display o conteudo da aba atual
func mudar_aba(nova_aba : Aba) -> void:
	# sai da aba anterior, e libera o conteudo dela
	atual_aba.sair_aba()
	for node in panel_conteudo.get_children():
		node.queue_free()
		
	# entra na nova aba
	atual_aba = nova_aba
	nova_aba.entrar_aba()
	# muda o address para o da aba
	label_address.text = nova_aba.texto_url
	
	# load conteudo da nova aba
	var conteudo_ref := nova_aba.conteudo
	var conteudo := conteudo_ref.instantiate()
	panel_conteudo.add_child(conteudo)
	
	if nova_aba.name == "Aba":
		var conteudo1 : Conteudo1 = conteudo
		conteudo1.button.pressed.connect(criar_aba)

func deletar_aba(aba : Aba) -> void:
	var aba_padrao : Aba = abas_por_titulo[titulo_aba_padrao]
	mudar_aba(aba_padrao)
	
	#panel_conteudo.remove_child(aba)
	aba.queue_free()

func criar_aba() -> void:
	var aba_criada : Aba = ABA_REF.instantiate()
	aba_criada.titulo = "Nova aba"
	aba_criada.fechavel = true
	aba_criada.conteudo = load("res://scene/Navegador/Conteudo2.tscn")
	add_aba(aba_criada)

func add_aba(aba : Aba) -> void:
	abas_por_titulo[aba.titulo] = aba
	aba.clicada.connect(mudar_aba.bind(aba))
	aba.fechada.connect(deletar_aba.bind(aba))
	h_box_abas.add_child(aba)
