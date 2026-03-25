class_name NavegadorConteudo
extends Panel

@onready var panel_conteudo: PanelContainer = $Margin/PanelConteudo

func mostrar_conteudo(conteudo_ref: PackedScene) -> void:
	# deleta o conteudo q estava sendo mostrado
	# TODO: colocar solucao melhor do que essa 
	for node in panel_conteudo.get_children():
		node.queue_free()
	
	# coloca o novo conteudo
	var conteudo = conteudo_ref.instantiate()
	panel_conteudo.add_child(conteudo)
