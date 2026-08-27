extends Control

@onready var start_menu: MarginContainer = $StartMenu

func _ready() -> void:
	if start_menu.visible:
		toggle_visibility(start_menu)


# Alterna a visibilidade do popup menu.
# Quando o menu está visível, ele é ocultado;
# caso contrário, ele é exibido.
func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true

func _on_home_pressed() -> void:
	toggle_visibility(start_menu)
