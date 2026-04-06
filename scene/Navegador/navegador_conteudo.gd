class_name NavegadorConteudo
extends Panel

@onready var panel_conteudo: PanelContainer = $Margin/PanelConteudo

@export var conteudos_abas_minimizadas : Node

var conteudo_por_aba : Dictionary[Aba, Node] = {}

## coloca um novo conteudo "do site" a ser mostrado no navegador
func mostrar_conteudo(aba : Aba) -> void:
	# minimiza o conteudo que esta sendo mostrado
	_minimizar_conteudo_atual()
	# pega o conteudo minimizado da aba para ser mostrado
	_display_conteudo_minimizado(aba)

##
func criar_conteudo(aba : Aba, conteudo_ref : PackedScene) -> void:
	# cria o novo conteudo para colocar na aba
	#var conteudo_ref := aba.conteudo
	var conteudo = conteudo_ref.instantiate()
	# 
	conteudo_por_aba[aba] = conteudo
	#
	conteudos_abas_minimizadas.add_child(conteudo)
	
	# TODO: teste, colocar solucao melhor depois
	if conteudo is Conteudo3:
		conteudo_3 = conteudo
		conteudo.terminado.connect(conteudo_3_completo)

# TODO: teste, colocar solucao melhor depois
var conteudo_3 : Conteudo3 = null
func conteudo_3_completo() -> void:
	conteudo_3.set_process(false)
	conteudo_3.set_physics_process(false)
	call_deferred("remover")

# TODO: teste, colocar solucao melhor depois
func remover() -> void:
	panel_conteudo.remove_child(conteudo_3)

## minimiza o conteudo q estava sendo mostrado
func _minimizar_conteudo_atual() -> void:
	for node in panel_conteudo.get_children():
		panel_conteudo.remove_child(node)
		conteudos_abas_minimizadas.add_child(node)

func _display_conteudo_minimizado(aba: Aba) -> void:
	# pega o conteudo que ja existe e esta minimizado
	var conteudo := conteudo_por_aba[aba]
	conteudos_abas_minimizadas.remove_child(conteudo)
	# display o conteudo da aba
	_display_conteudo(conteudo)

func _display_conteudo(conteudo : Node) -> void:
	panel_conteudo.add_child(conteudo)

## libera da memoria o conteudo da aba
func liberar_conteudo_aba(aba: Aba) -> void:
	if conteudo_por_aba.has(aba):
		# deleta o conteudo da aba
		conteudo_por_aba[aba].queue_free()
		# apaga do dicionario
		conteudo_por_aba.erase(aba)
