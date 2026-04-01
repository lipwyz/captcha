class_name NavegadorConteudo
extends Panel

@onready var panel_conteudo: PanelContainer = $Margin/PanelConteudo

## coloca um novo conteudo "do site" a ser mostrado no navegador
func mostrar_conteudo(conteudo_ref: PackedScene) -> void:
	# deleta o conteudo q estava sendo mostrado
	# TODO: colocar solucao melhor do que essa 
	for node in panel_conteudo.get_children():
		node.queue_free()
	
	# coloca o novo conteudo
	var conteudo = conteudo_ref.instantiate()
	panel_conteudo.add_child(conteudo)
	
	# TODO: teste, colocar solucao melhor depois
	if conteudo is Conteudo3:
		conteudo_3 = conteudo
		conteudo.completada.connect(conteudo_3_completo)

# TODO: teste, colocar solucao melhor depois
var conteudo_3 : Conteudo3 = null
func conteudo_3_completo() -> void:
	conteudo_3.set_process(false)
	conteudo_3.set_physics_process(false)
	call_deferred("remover")

# TODO: teste, colocar solucao melhor depois
func remover() -> void:
	panel_conteudo.remove_child(conteudo_3)
