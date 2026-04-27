class_name AreaTrabalho
extends Control

@export var navegador: Navegador

# ao apertar o icone do explorer -> abrir o navegador
func _on_button_explorer_pressed() -> void:
	navegador.abrir()
