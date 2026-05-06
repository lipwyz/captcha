class_name Conteudo1
extends ConteudoAba

@export var nova_aba: MiniGameRes

func _on_button_pressed() -> void:
	var fechavel: bool = true
	GerenciadorGlobal.pedir_criar_aba(nova_aba, fechavel)
