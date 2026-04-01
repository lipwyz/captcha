class_name NavegadorControles
extends Panel

signal fechar
signal minimizar
signal maximizar

@onready var label_url: Label = $VBox/MarginHotBar/PanelHotBar/HBox/PanelAddress/Margin/LabelUrl
@onready var h_box_abas: HBoxContainer = $VBox/MarginAbasBar/HBoxAbas

## muda o url que esta sendo mostrado atualmente
func mudar_url(texto_url: String) -> void:
	label_url.text = texto_url

## adiciona a ui da aba na linha abas
func add_aba(aba : Aba) -> void:
	h_box_abas.add_child(aba)

# --- Conecta os botoes aos seus respectivos sinais ---
func _on_button_fechar_navegador_pressed() -> void:
	emit_signal("fechar")

func _on_button_maximizar_pressed() -> void:
	emit_signal("maximizar")

func _on_button_minimizar_pressed() -> void:
	emit_signal("minimizar")
