extends Control 

@onready var start_menu: MarginContainer = $StartMenu
@onready var quit_menu: MarginContainer = $QuitMenu


func _ready() -> void:
	if start_menu.visible and quit_menu.visible:
		toggle_visibility(start_menu)
		toggle_visibility(quit_menu)


# Alterna a visibilidade do popup menu.
# Quando o menu está visível, ele é ocultado;
# caso contrário, ele é exibido.
func toggle_visibility(object):
	object.visible = not object.visible

# Função chamada quando o botão "Home" for pressionado.
func _on_home_pressed() -> void:
	toggle_visibility(start_menu)
	# Verifica se o quit_menu está visível.
	if quit_menu.visible:
		toggle_visibility(quit_menu)

# Função chamada quando o botão "Quit" for pressionado.
# Alterna a visibilidade do menu de saída.
# Mostra se estiver escondido e esconde se estiver visível.
func _on_quit_pressed() -> void:
	toggle_visibility(quit_menu)

# Função chamada quando o botão "Desktop" for pressionado.
func _on_desktop_pressed() -> void:
	get_tree().quit()

# Função chamada quando o botão "Main Menu" for pressionado.
func _on_main_menu_pressed() -> void:
	pass # Replace with function body.
