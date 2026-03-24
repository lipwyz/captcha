class_name Conteudo1
extends Control

@export var navegador : Navegador

func _on_button_pressed() -> void:
	var aba := Aba.criar_aba("Nova Aba", true, Aba.Estados.Idle, "https://teste/teste.com")
	navegador.add_aba(aba)
	navegador.set_conteudo_aba(aba, load("res://scene/Navegador/conteudoTeste/Conteudo2.tscn"))
