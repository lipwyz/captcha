class_name NavegadorControles
extends Panel

signal fechar

@onready var label_url: Label = $VBox/MarginHotBar/PanelHotBar/HBox/PanelAddress/Margin/LabelUrl
@onready var h_box_abas: HBoxContainer = $VBox/MarginAbasBar/HBoxAbas

func mudar_url(texto_url: String) -> void:
	label_url.text = texto_url

func add_aba(aba : Aba) -> void:
	h_box_abas.add_child(aba)

func _on_button_fechar_navegador_pressed() -> void:
	emit_signal("fechar")
