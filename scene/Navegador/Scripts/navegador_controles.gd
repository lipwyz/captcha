class_name NavegadorControles
extends Panel

signal fechar
signal minimizar
signal maximizar

@onready var label_url: Label = $VBox/MarginHotBar/PanelHotBar/HBox/PanelAddress/Margin/LabelUrl
@onready var h_box_abas: HBoxContainer = $VBox/MarginAbasBar/HBox/HBoxAbas
@onready var h_box_setas: HBoxContainer = $VBox/MarginAbasBar/HBox/HBoxSetas

@export_range(1,32,1, "Maximo de abas mostradas na tela até as setinhas aparecerem")
var max_abas_mostradas : int = 7

var abas_list : Array[Aba] = []
## index da primeira aba que esta sendo mostrada
var abas_mostradas_index : int = 0

func _ready() -> void:
	h_box_setas.hide()

## muda o url que esta sendo mostrado atualmente
func mudar_url(texto_url: String) -> void:
	label_url.text = texto_url

## adiciona a ui da aba na linha abas
func add_aba(aba : Aba) -> void:
	h_box_abas.add_child(aba)
	abas_list.append(aba)
	_verificar_clipar_abas_mostradas()

func remove_aba(aba : Aba) -> void:
	abas_list.erase(aba)
	_verificar_clipar_abas_mostradas()
	aba.queue_free()

# --- Clipar abas mostradas ---

func _verificar_clipar_abas_mostradas() -> void:
	if abas_list.size() > max_abas_mostradas:
		clipar_abas_mostradas()
		h_box_setas.show()
	else:
		h_box_setas.hide()

func clipar_abas_mostradas() -> void:
	# escondo todas as abas
	abas_list.map(func(aba : Aba): aba.hide())
	# mostra so as max_abas_mostradas partindo da aba de indice abas_mostradas_index
	# ate o index da ultima aba a ser mostrada, ou a quantidade de abas
	var ate_index : int = abas_mostradas_index + max_abas_mostradas
	print("ate_index ", ate_index)
	ate_index = min(ate_index, abas_list.size())
	print("ate_index min ", ate_index)
	# mostra as abas selecionadas
	for i in range(abas_mostradas_index, ate_index): 
		abas_list[i].show()
	#

func _clipar_move_esquerda() -> void:
	if abas_list.size() <= max_abas_mostradas: return
	# diminui 1 o index, ate zero
	abas_mostradas_index = max(0, abas_mostradas_index-1)
	clipar_abas_mostradas()

func _clipar_move_direita() -> void:
	if abas_list.size() <= max_abas_mostradas: return
	# aumenta 1 o index, ate limite de index a direita
	var lim_index_dir : int = abas_list.size() - max_abas_mostradas
	abas_mostradas_index = min(lim_index_dir, abas_mostradas_index+1)
	clipar_abas_mostradas()

# --- Conecta os botoes aos seus respectivos sinais ---
func _on_button_fechar_navegador_pressed() -> void:
	emit_signal("fechar")

func _on_button_maximizar_pressed() -> void:
	emit_signal("maximizar")

func _on_button_minimizar_pressed() -> void:
	emit_signal("minimizar")


# detectar o click na aba, para clicar e entrar em uma aba
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			_clipar_move_direita()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			_clipar_move_esquerda()
