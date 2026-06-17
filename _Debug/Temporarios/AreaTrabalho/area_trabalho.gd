class_name AreaTrabalho
extends Control

signal click_navegador

## Apertar o icone do explorer
func _on_button_explorer_pressed() -> void:
	click_navegador.emit()
